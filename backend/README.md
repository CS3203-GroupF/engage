# Backend

The backend for the OU Engage 2 project.

## Setup

First, you need to set up the database:

1. Install SQLite: `sudo dnf install sqlite` on Fedora; `brew install sqlite3` on macOS.
1. Install Rust (and Cargo!) using this command: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
1. Remove any existing database files: `rm engage.db engage.db-shm  engage.db-wal`
1. Create a new SQLite database: `cat tables.sql | sqlite3 engage.db`
1. Fill it with data: `cargo run --bin generate_sql_file`
