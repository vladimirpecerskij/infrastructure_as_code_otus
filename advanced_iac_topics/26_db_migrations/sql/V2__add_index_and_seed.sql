CREATE INDEX idx_posts_user_id ON posts(user_id);

INSERT INTO users (username, email) VALUES ('admin', 'admin@iac-otus.ru');
INSERT INTO posts (user_id, title, body) VALUES (1, 'First IaC Post', 'Database schema managed by Flyway!');
