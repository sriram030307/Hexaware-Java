-- Set 2: Airline booking transaction and locking
CREATE DATABASE IF NOT EXISTS airline_day8;
USE airline_day8;
CREATE TABLE IF NOT EXISTS seats(flight_id INT,seat_no VARCHAR(5),
 status ENUM('AVAILABLE','BOOKED') DEFAULT 'AVAILABLE',
 PRIMARY KEY(flight_id,seat_no)) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS bookings(booking_id BIGINT AUTO_INCREMENT PRIMARY KEY,
 flight_id INT,seat_no VARCHAR(5),passenger VARCHAR(80),fare DECIMAL(10,2),
 booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_flight_seat(flight_id,seat_no)) ENGINE=InnoDB;
INSERT IGNORE INTO seats VALUES(501,'12A','AVAILABLE'),(501,'12B','AVAILABLE');

-- Run inside one session. Check status and affected rows in application.
START TRANSACTION;
SELECT status FROM seats WHERE flight_id=501 AND seat_no='12A' FOR UPDATE;
-- Continue only if one row is AVAILABLE:
INSERT INTO bookings(flight_id,seat_no,passenger,fare) VALUES(501,'12A','Nila',4500);
UPDATE seats SET status='BOOKED' WHERE flight_id=501 AND seat_no='12A' AND status='AVAILABLE';
-- If update affected rows != 1, ROLLBACK.
COMMIT;

-- Concurrency experiment:
-- Session A: START TRANSACTION; SELECT status FROM seats WHERE flight_id=501
-- AND seat_no='12B' FOR UPDATE; (hold lock)
-- Session B: execute same SELECT FOR UPDATE; it waits.
-- A inserts booking, updates seat to BOOKED, COMMITs.
-- B resumes, sees BOOKED; do not insert; ROLLBACK.
-- UNIQUE(flight_id,seat_no) prevents duplicate bookings as final safeguard.
