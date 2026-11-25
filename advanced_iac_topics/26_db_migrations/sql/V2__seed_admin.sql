INSERT INTO app_users (username, email)
VALUES ('admin', 'admin@example.com')
ON CONFLICT (username) DO NOTHING;
