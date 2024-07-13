CREATE SCHEMA IF NOT EXISTS accommodation_db;

CREATE TABLE IF NOT EXISTS accommodation_db.hotel (
    hotel_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,
    rating INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS accommodation_db.room (
    room_id SERIAL PRIMARY KEY,
    hotel_id INTEGER NOT NULL,
    number INTEGER NOT NULL,
    type VARCHAR(10) NOT NULL,
    daily_price REAL NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES accommodation_db.hotel (hotel_id)
);

CREATE TABLE IF NOT EXISTS accommodation_db.client (
    client_id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(200) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    cpf VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS accommodation_db.accommodation (
    accommodation_id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    amount REAL NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES accommodation_db.client (client_id),
    FOREIGN KEY (room_id) REFERENCES accommodation_db.room (room_id)
);
