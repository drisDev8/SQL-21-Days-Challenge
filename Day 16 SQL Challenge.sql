-- Day 16

-- 1. Find patients who are in services with above-average staff count.
SELECT p.patient_id, p.name, p.service
FROM patients p
WHERE p.service IN (
    SELECT s.service
    FROM staff s
    GROUP BY s.service
    HAVING COUNT(s.staff_id) > (
        SELECT AVG(staff_count)
        FROM (
            SELECT COUNT(staff_id) AS staff_count
            FROM staff
            GROUP BY service
        ) AS subquery
    )
);

-- 2. List staff who work in services that had any week with patient satisfaction below 70.
SELECT DISTINCT staff_id
FROM staff 
WHERE service IN (
SELECT service 
FROM services_weekly
WHERE patient_satisfaction < 70);

-- 3. Show patients from services where total admitted patients exceed 1000.
SELECT patient_id, service
FROM patients
WHERE service IN(
SELECT service
FROM services_weekly
GROUP BY service
HAVING SUM(patients_admitted) > 1000
);

/* Daily Challenge: Find all patients who were admitted to services that had at least one week where patients were refused AND the average patient satisfaction for that 
service was below the overall hospital average satisfaction. Show patient_id, name, service, and their personal satisfaction score. */
SELECT patient_id, name, service, satisfaction
FROM patients 
WHERE service IN (
SELECT service
FROM services_weekly
GROUP BY service
HAVING AVG(patient_satisfaction) < (
SELECT AVG(patient_satisfaction)
FROM services_weekly
)
);

