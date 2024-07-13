-- Select all available hotels and their rooms.
SELECT hotel.name, hotel.city, room.type AS room_type, room.daily_price AS room_daily_price
FROM accommodation_db.hotel hotel, accommodation_db.room room
WHERE hotel.hotel_id = room.hotel_id
ORDER BY room.room_id ASC;

-- Update room daily_price with ID 12 because it's out of the pattern in the fictitious data already inserted into room table.
UPDATE accommodation_db.room
SET daily_price = 1502.72
WHERE room_id = 12;

-- Select all clients whose accommodation is finished.
SELECT client.name, client.telephone, hotel.name AS hotel_name, room.number AS room_number
FROM accommodation_db.client client, accommodation_db.hotel hotel, accommodation_db.room room, accommodation_db.accommodation accommodation
WHERE accommodation.client_id = client.client_id
AND accommodation.room_id = room.room_id
AND room.hotel_id = hotel.hotel_id
AND accommodation.status = 'finished';

-- Select accommodation historical of some client.
SELECT *
FROM accommodation_db.accommodation accommodation
WHERE accommodation.client_id = 1
ORDER BY accommodation.checkin_date DESC;

-- Select client with more accommodations.
SELECT client.*, COUNT(accommodation) AS accommodations
FROM accommodation_db.client client, accommodation_db.accommodation accommodation
WHERE client.client_id = accommodation.client_id
GROUP BY client.client_id
ORDER BY accommodations DESC
LIMIT 1;

-- Clients with canceled accommodations.
SELECT client.name, room.number AS room_number, hotel.name AS hotel_name
FROM accommodation_db.client client
LEFT JOIN accommodation_db.accommodation accommodation ON client.client_id = accommodation.client_id AND accommodation.status = 'canceled'
LEFT JOIN accommodation_db.room room ON accommodation.room_id = room.room_id
LEFT JOIN accommodation_db.hotel hotel ON room.hotel_id = hotel.hotel_id
GROUP BY client.name, room_number, hotel_name;

-- Hotel cash in.
SELECT hotel.name, SUM(accommodation.amount) AS cash_in
FROM accommodation_db.accommodation accommodation
LEFT JOIN accommodation_db.room room ON accommodation.room_id = room.room_id
LEFT JOIN accommodation_db.hotel hotel ON room.hotel_id = hotel.hotel_id
WHERE accommodation.status = 'finished'
GROUP BY hotel.name
ORDER BY cash_in DESC;

-- Select clients that have accommodation(s) with a specific hotel.
SELECT client.name, client.telephone, hotel.name AS hotel_name
FROM accommodation_db.client client
LEFT JOIN accommodation_db.accommodation accommodation ON client.client_id = accommodation.client_id
LEFT JOIN accommodation_db.room room ON accommodation.room_id = room.room_id
LEFT JOIN accommodation_db.hotel hotel ON room.hotel_id = hotel.hotel_id
WHERE hotel.hotel_id = 1
GROUP BY client.client_id, hotel_name;

-- How much each client spent in accommodations.
SELECT client.name, SUM(accommodation.amount) AS accommodation_ammount
FROM accommodation_db.client client
LEFT JOIN accommodation_db.accommodation accommodation ON client.client_id = accommodation.client_id AND accommodation.status = 'finished'
GROUP BY client.client_id
ORDER BY accommodation_ammount DESC;

-- Rooms don't used yet.
SELECT room.number AS room_number, hotel.name AS hotel_name
FROM accommodation_db.room room
LEFT JOIN accommodation_db.hotel hotel ON room.hotel_id = hotel.hotel_id
WHERE (
    SELECT NOT EXISTS (
        SELECT 1
        FROM accommodation_db.accommodation accommodation
        WHERE accommodation.room_id = room.room_id
        AND accommodation.status <> 'canceled'
    )
)
ORDER BY hotel_name DESC;

-- Average daily price of each room type from hotels.
SELECT hotel.name AS hotel_name, room.type AS room_type, AVG(room.daily_price) AS avg_room_daily_price
FROM accommodation_db.hotel hotel
LEFT JOIN accommodation_db.room room ON room.hotel_id = hotel.hotel_id
GROUP BY hotel_name, room_type
ORDER BY avg_room_daily_price ASC;

-- Add column checkin_done in the accommodation table.
ALTER TABLE accommodation_db.accommodation
ADD COLUMN checkin_done BOOLEAN DEFAULT FALSE;

-- Update checkin_done column properly.
SET search_path TO accommodation_db;
UPDATE accommodation
SET checkin_done = (status = 'ongoing' OR status = 'finished');

-- Change column name of hotel table for a correct one.
ALTER TABLE accommodation_db.hotel
RENAME COLUMN rating TO ratting;
