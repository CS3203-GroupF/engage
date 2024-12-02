use std::str::FromStr as _;

use actix_web::{get, web, App, HttpServer, Responder};
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
