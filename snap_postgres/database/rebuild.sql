DROP DATABASE IF EXISTS snap_db;
DROP OWNED BY snap;
DROP USER snap;

-- Database conf should only allow connections from localhost
CREATE USER snap WITH PASSWORD 'snap_password';
CREATE DATABASE snap_db;

\connect snap_db
\i update.sql

-- Not a great solution, but everything would probably be under one schema anyways
GRANT SELECT, INSERT, UPDATE, DELETE
      ON ALL TABLES IN SCHEMA public
      TO snap;
