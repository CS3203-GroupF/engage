PRAGMA foreign_keys = ON;

-- Delete Contact Table from the the database if present already --
DROP TABLE IF EXISTS contacts;
-- Delete Organization Table from the the database if present already --
DROP TABLE IF EXISTS orgs;

--Create the Organization Table and Attributes--
CREATE TABLE orgs (
    org_id INTEGER PRIMARY KEY NOT NULL,
    org_name TEXT NOT NULL, 
    member_ct INTEGER,
    descr TEXT NOT NULL,
    keywords TEXT NOT NULL
);

--Create the Contact Table and Attributes--n
CREATE TABLE contacts (
    contact_id INTEGER PRIMARY KEY,
    org_id INTEGER NOT NULL,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    addr TEXT,

    -- hint that the org id is talking about an organization --
    FOREIGN KEY (org_id) REFERENCES orgs(org_id)
);