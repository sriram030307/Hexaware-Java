-- Set 2: Fare ranking, running revenue and correlated average
USE airline_day8;
WITH fare_rank AS (
 SELECT flight_id,passenger,fare,
 RANK() OVER(PARTITION BY flight_id ORDER BY fare DESC) rnk,
 DENSE_RANK() OVER(PARTITION BY flight_id ORDER BY fare DESC) dense_rnk
 FROM bookings
)
SELECT * FROM fare_rank ORDER BY flight_id,rnk,passenger;

WITH revenue AS (
 SELECT flight_id,booking_id,booked_at,fare,
 SUM(fare) OVER(PARTITION BY flight_id ORDER BY booked_at,booking_id
 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_revenue
 FROM bookings
)
SELECT * FROM revenue ORDER BY flight_id,booking_id;

-- Passenger fares above the average fare for their flight
SELECT b.flight_id,b.passenger,b.fare
FROM bookings b
WHERE b.fare>(SELECT AVG(x.fare) FROM bookings x WHERE x.flight_id=b.flight_id);
