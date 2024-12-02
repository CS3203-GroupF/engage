use std::{collections::HashMap, str::FromStr as _};

use actix_web::{get, web, App, HttpServer, Responder};
use fuzzy_matcher::{skim::SkimMatcherV2, FuzzyMatcher as _};
use serde::{Deserialize, Serialize};
use sqlx::{
    sqlite::{SqliteConnectOptions, SqliteJournalMode},
    SqlitePool,
};
use tracing::Level;

/// The path on disk where the Engage database is stored.
pub const ENGAGE_DB_PATH: &str = "sqlite://engage.db";

/// App state to assist in handling the frontend's requests.
#[derive(Clone, Debug)]
pub struct State {
    /// A link to the database.
    ///
    /// This is actually a "pool" of connections, meaning multiple things can use
    /// the database at once!
    ///
    /// You'll notice this is particularly useful with a web server, which is what
    /// we're building here. ;D
    pub db: SqlitePool,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct Org {
    pub org_id: i64,
    pub org_name: String,
    pub descr: String,
    pub member_ct: Option<i64>,
    pub keywords: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct Contact {
    pub contact_id: i64,
    pub org_id: i64,
    pub first_name: Option<String>,
    pub last_name: Option<String>,
    pub email: Option<String>,
    pub phone: Option<String>,
    pub addr: Option<String>,
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // turn on logging
    tracing_subscriber::fmt()
        .pretty()
        .with_max_level(Level::DEBUG)
        .init();

    // init the http server
    HttpServer::new(|| {
        App::new()
            //
            // add the different routes that the frontend can use
            .service(org_by_id)
            .service(org_by_name)
            .service(org_contact_by_id)
            .service(fuzzy_search_orgs)
            //
            // add app state to the global `App`
            .app_data(web::Data::new(State {
                db: SqlitePool::connect_lazy_with(
                    SqliteConnectOptions::from_str(ENGAGE_DB_PATH)
                        .unwrap_or_else(|_| {
                            panic!("database file should exist at {}", ENGAGE_DB_PATH)
                        })
                        .journal_mode(SqliteJournalMode::Wal)
                        .read_only(false),
                ),
            }))
    })
    .bind(("127.0.0.1", 1111))? // you can talk to the backend (NOT the website frontend) here!
    .run()
    .await
}

/// Grabs an organzation by its ID.
#[get("/org/id/{org_id}")]
#[tracing::instrument(skip(state))]
async fn org_by_id(
    path: web::Path<u32>,
    state: web::Data<State>,
) -> actix_web::Result<impl Responder> {
    let org_id = path.into_inner();

    // check for the org from its id
    let org = sqlx::query_as!(Org, r#"SELECT * FROM orgs WHERE org_id = $1"#, org_id)
        .fetch_one(&state.db)
        .await;

    match org {
        Ok(org) => Ok(web::Json(org)),
        Err(e) => {
            tracing::info!("Failed to find org with id {org_id}. (err: {e})");
            Err(actix_web::error::ErrorNotFound(format!(
                "didn't find an org with id `{org_id}`"
            )))
        }
    }
}

/// Grabs an organization by its name.
#[get("org/name/{org_name}")]
#[tracing::instrument]
async fn org_by_name(
    path: web::Path<String>,
    state: web::Data<State>,
) -> actix_web::Result<impl Responder> {
    let org_name = path.into_inner();

    // check for the org from its id
    let org = sqlx::query_as!(Org, r#"SELECT * FROM orgs WHERE org_name = $1"#, org_name)
        .fetch_one(&state.db)
        .await;

    match org {
        Ok(org) => Ok(web::Json(org)),
        Err(e) => {
            tracing::info!("Failed to find org with id {org_name}. (err: {e})");
            Err(actix_web::error::ErrorNotFound(format!(
                "didn't find an org with name `{org_name}`"
            )))
        }
    }
}

/// Grabs an organzation's contact using its ID.
///
/// Please note that some fields can be `NULL` ([`Option::None`]) on the
/// [`Contact`] we find!
#[get("/org/id/{org_id}/contact")]
#[tracing::instrument(skip(state))]
async fn org_contact_by_id(
    path: web::Path<u32>,
    state: web::Data<State>,
) -> actix_web::Result<impl Responder> {
    let org_id = path.into_inner();

    // check for the org from its id
    let contact = sqlx::query_as!(
        Contact,
        r#"SELECT * FROM contacts WHERE org_id = $1"#,
        org_id
    )
    .fetch_one(&state.db)
    .await;

    match contact {
        Ok(contact) => Ok(web::Json(contact)),
        Err(e) => {
            tracing::info!("Failed to find contact for org with ID {org_id}. (err: {e})");
            Err(actix_web::error::ErrorNotFound(format!(
                "didn't find contact for org w/ id {org_id}"
            )))
        }
    }
}

#[derive(Clone, Debug, Deserialize)]
pub struct SearchQuery {
    pub query: String,
}

/// Using fuzzy search, grabs organizations with similar words to the query.
///
/// Example URL: `http://localhost:1111/fuzzy_search?query=computer`
#[get("/fuzzy_search")]
#[tracing::instrument(skip_all)]
async fn fuzzy_search_orgs(
    query: web::Query<SearchQuery>,
    state: web::Data<State>,
) -> actix_web::Result<impl Responder> {
    // grab our query
    let query = &query.query;
    tracing::debug!("got query `{query}`!");

    // search for orgs
    //
    // FIXME: this is hilariously slow. please dont deserialize ur entire db
    // for one server response, kids.
    //
    // but dear god, if you do, at least cache the result LOL
    let orgs: Vec<Org> = match sqlx::query_as!(Org, "SELECT * FROM orgs")
        .fetch_all(&state.db)
        .await
    {
        Ok(good_orgs) => good_orgs,
        Err(e) => {
            tracing::error!("Failed to check db for orgs!!! (err: {e})");
            return Err(actix_web::error::ErrorInternalServerError(
                "failed to access database..?",
            ));
        }
    };

    // grab the top 12
    let top_matches = {
        let fuzzy_matcher = SkimMatcherV2::default();
        let mut all = orgs
            .into_iter()
            .map(|org| {
                // also search on just the org's name, and weight it really big
                let high = fuzzy_matcher.fuzzy_match(&org.org_name, query);

                // and tags can be medium
                let medium = fuzzy_matcher.fuzzy_match(&org.keywords, query);

                let low = fuzzy_matcher.fuzzy_match(&org.descr, query);

                let total_score = high.map(|h| h * 10).unwrap_or(0)
                    + medium.map(|m| m * 4).unwrap_or(0)
                    + low.unwrap_or(0);

                (org.clone(), total_score)
            })
            .collect::<Vec<_>>();

        all.sort_unstable_by_key(|(_, score)| *score); // sort by score
        all.reverse(); // with highest score first!

        let mut top_12 = Vec::new();

        for i in 0..12 {
            top_12.push(all.get(i).map(|(org, _score)| org).cloned());
        }

        top_12
    };

    Ok(web::Json(top_matches))
}
