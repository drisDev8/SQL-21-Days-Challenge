/* DAY 7: Practice Questions */
-- 1. Find services that have admitted more than 500 patients in total.
SELECT service, SUM(patients_admitted) as total_admitted
FROM services_weekly
GROUP BY service
HAVING SUM(patients_admitted) > 500;

-- 2. Show services where average patient satisfaction is below 75.
SELECT service, ROUND(AVG(patient_satisfaction),2) AS avg_satisfaction
FROM services_weekly
GROUP BY service
HAVING AVG(patient_satisfaction) < 75;

-- 3. List weeks where total staff presence across all services was less than 50.
SELECT week, SUM(present) AS total_staff_presence
FROM staff_schedule
GROUP BY week
HAVING SUM(present) < 50;

/* Daily Challenge: Identify services that refused more than 100 patients in total and had an average patient satisfaction below 80. 
Show service name, total refused, and average satisfaction. */
SELECT service, 
SUM(patients_refused) AS total_refused,
ROUND(AVG(patient_satisfaction),2) AS avg_satisfaction
FROM services_weekly
GROUP BY service
HAVING SUM(patients_refused) > 100 AND AVG(patient_satisfaction) < 80;










