
CREATE TABLE IF NOT EXISTS projects (
  id SERIAL,
  title TEXT NOT NULL,
  description TEXT NOT NULL
);

INSERT INTO projects(title, description)
       SELECT 'A project', 'A description'
       WHERE NOT EXISTS (SELECT 1 FROM projects WHERE id=1);

