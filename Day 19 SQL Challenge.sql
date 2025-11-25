-- Day 19

-- 1. Rank patients by satisfaction score within each service.
SELECT patient_id, 
ROW_NUMBER() OVER(PARTITION BY service ORDER BY satisfaction) AS rn
FROM patients;
 
-- 2. Assign row numbers to staff ordered by their name.
SELECT *,
ROW_NUMBER() OVER(ORDER BY staff_name) as rn
FROM staff;

-- 3. Rank services by total patients admitted.
SELECT service, total_admitted,
ROW_NUMBER() OVER(ORDER BY total_admitted) AS rn
FROM (
SELECT service, 
SUM(patients_admitted) AS total_admitted
FROM services_weekly
GROUP BY service
	) AS subq;

/* Daily Challenge: For each service, rank the weeks by patient satisfaction score (highest first). Show service, week, patient_satisfaction, patients_admitted, and the rank. 
Include only the top 3 weeks per service.*/
SELECT service, week, patient_satisfaction, patients_admitted, rn
FROM (
SELECT service, week, patient_satisfaction, patients_admitted, 
ROW_NUMBER() OVER(PARTITION BY service ORDER BY patient_satisfaction DESC) AS rn
FROM services_weekly
) AS subq
WHERE rn <= 3;



