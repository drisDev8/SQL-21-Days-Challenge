/* DAY 5: Practice Questions */
-- 1. Count the total number of patients in the hospital.
SELECT COUNT(*) AS total_patients
FROM patients;

-- 2. Calculate the average satisfaction score of all patients.
SELECT ROUND(AVG(satisfaction),2) AS satisfaction_score
FROM patients;

-- 3. Find the minimum and maximum age of patients.
SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM patients;

/* Daily Challenge: Calculate the total number of patients admitted, total patients refused, and the average patient satisfaction across all services and weeks. 
Round the average satisfaction to 2 decimal places.*/
SELECT week, service,
SUM(patients_admitted) AS total_admitted, 
SUM(patients_refused) AS total_refused, 
ROUND(AVG(patient_satisfaction),2) AS avg_satifaction
FROM services_weekly
GROUP BY week, service;

