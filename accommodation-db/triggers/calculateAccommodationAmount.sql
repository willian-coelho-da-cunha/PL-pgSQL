SET search_path TO accommodation_db;
CREATE OR REPLACE FUNCTION calculateAccommodationAmount()
RETURNS TRIGGER AS $$
BEGIN
    NEW.amount := ((NEW.checkout_date - NEW.checkin_date) + 1) * (SELECT room.daily_price FROM room room WHERE room.room_id = NEW.room_id LIMIT 1);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calculateAccommodationAmount_trigger
BEFORE INSERT OR UPDATE ON accommodation
FOR EACH ROW
EXECUTE FUNCTION calculateAccommodationAmount();
