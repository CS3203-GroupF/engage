use std::{collections::HashMap, fs::File, io::BufReader, str::FromStr as _};

use csv::Reader;
use serde::{Deserialize, Serialize};
use sqlx::{
    sqlite::{SqliteConnectOptions, SqliteJournalMode},
    SqlitePool,
};

#[derive(Clone, Debug, Serialize, Deserialize)]
struct OrgRecord {
    pub org_id: u32,
    pub org_name: String,
    pub descr: String,
    pub member_ct: Option<u16>,
    pub keywords: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct ContactRecord {
    contact_id: u32,
    org_id: u32,
    first_name: Option<String>,
    last_name: Option<String>,
    email: Option<String>,
    phone: Option<String>,
    addr: Option<String>,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // grab all the orgs
    let orgs = get_orgs();
    let contacts = get_contacts();

    let db_path = "sqlite:engage.db";

    // connect to db
    let db = SqlitePool::connect_lazy_with(
        SqliteConnectOptions::from_str(db_path)
            .unwrap_or_else(|_| panic!("database file should exist at `{}`", db_path))
            .journal_mode(SqliteJournalMode::Wal)
            .read_only(false),
    );

    // add each org into the `orgs` table
    for org in orgs {
        let _ = sqlx::query!(
            r#"
            INSERT INTO orgs (org_id, org_name, member_ct, descr, keywords)
            VALUES ($1, $2, $3, $4, $5)
            "#,
            org.org_id,
            org.org_name,
            org.member_ct,
            org.descr,
            org.keywords
        )
        .execute(&db)
        .await
        .expect("org creation queries should succeed!");
    }

    // and contacts
    for contact in contacts {
        let _ = sqlx::query!(
            r#"
            INSERT INTO contacts (contact_id, org_id, first_name, last_name, email, phone, addr)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            "#,
            contact.contact_id,
            contact.org_id,
            contact.first_name,
            contact.last_name,
            contact.email,
            contact.phone,
            contact.addr,
        )
        .execute(&db)
        .await
        .expect("org creation queries should succeed!");
    }

    db.close().await;

    Ok(())
}

fn get_contacts() -> Vec<ContactRecord> {
    let mut rdr = Reader::from_reader(BufReader::new(File::open("contacts.csv").unwrap()));
    rdr.deserialize().flatten().collect()
}

/// Parses out the organizations from their CSV file.
fn get_orgs() -> Vec<OrgRecord> {
    // most info is in this file
    let mut rdr = Reader::from_reader(BufReader::new(File::open("orgs.csv").unwrap()));

    // weird, but we're also gonna open a secondary csv file and try to find
    // the member ct for each org by name
    let org_names_with_member_ct = {
        let mut map: HashMap<String, u16> = HashMap::new(); // orgs: a map from `name` to `member_ct`

        // this is from the weird (limited) file, `OrganizationDirectory4Kyle.csv`
        let mut weird_rdr = Reader::from_reader(BufReader::new(
            File::open("OrganizationDirectory4Kyle.csv").unwrap(),
        ));

        for entry in weird_rdr.records().flatten() {
            println!("entry: {entry:#?}");
            let (Some(name), Some(member_ct)) = (entry.get(0), entry.get(1)) else {
                continue;
            };
            println!("{name} made it past str getting!");

            // convert member ct (string) to u16 (number)
            let Ok(member_ct) = member_ct.parse::<u16>() else {
                continue;
            };
            println!("{name} made it past member ct conv ({member_ct} members!)");

            // put it in our map
            map.insert(name.trim().to_ascii_lowercase().to_string(), member_ct);
        }

        map
    };

    #[derive(Clone, Debug, Serialize, Deserialize)]
    struct BadOrgRecord {
        pub org_id: u32,
        pub org_name: String,
        pub descr: String,
        pub keywords: String,
    }

    let mut orgs = Vec::with_capacity(129);

    for r in rdr.deserialize() {
        // grab the record, without member ct
        let bad_record: BadOrgRecord = r.expect("record ok");
        let BadOrgRecord {
            org_id,
            org_name,
            keywords,
            descr,
        } = bad_record;

        // try to get member ct
        let member_ct = org_names_with_member_ct
            .get(&org_name.trim().to_ascii_lowercase())
            .cloned();
        println!("org w/ name {org_name} has {member_ct:?} members!");

        // form a good record
        let record = OrgRecord {
            org_id,
            org_name,
            descr,
            member_ct,
            keywords,
        };

        // push it to the list
        orgs.push(record);
    }

    // return org list :)
    orgs
}
