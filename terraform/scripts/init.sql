CREATE TABLE IF NOT EXISTS welcome_messages (
    id SERIAL PRIMARY KEY,
    message TEXT NOT NULL
);

INSERT INTO welcome_messages (message) VALUES ('Welcome to this website');
