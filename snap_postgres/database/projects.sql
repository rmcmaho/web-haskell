DROP DATABASE if exists snap_db;
CREATE DATABASE snap_db;
\connect snap_db

CREATE TABLE projects (
  id SERIAL,
  title TEXT NOT NULL,
  description TEXT NOT NULL
);

INSERT INTO projects(title, description) values('A project', 'A description');

GRANT ALL PRIVILEGES ON projects to snap;