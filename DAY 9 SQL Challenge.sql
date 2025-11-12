-- Day 9 SQL Challenge
-- 1. Extract the year from all patient arrival dates.
SELECT patient_id, arrival_date, year(arrival_date) AS Arrival_Year 
FROM patients; 

-- 2. Calculate the length of stay for each patient (departure_date - arrival_date).
SELECT patient_id, name, datediff(departure_date, arrival_date) AS length_of_stay
FROM patients;

-- 3. Find all patients who arrived in a specific month.
SELECT patient_id, name, arrival_date
FROM patients
WHERE EXTRACT(MONTH FROM arrival_date) = 4;

/* Daily Challenge: Calculate the average length of stay (in days) for each service, showing only services where the average stay is more than 7 days. 
Also show the count of patients and order by average stay descending. */

SELECT service, 
ROUND(AVG(DATEDIFF(departure_date, arrival_date)),2) AS avg_length_of_stay,
COUNT(*) AS patient_cnt
FROM patients
GROUP BY service 
HAVING AVG(DATEDIFF(departure_date, arrival_date))  > 7
ORDER BY avg_length_of_stay DESC;





