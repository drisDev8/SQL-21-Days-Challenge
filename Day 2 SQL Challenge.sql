/* DAY 2: Practice Questions */
-- 1. Find all patients who are older than 60 years.
SELECT patient_id, name, age
FROM patients
WHERE age > 60;

-- 2. Retrieve all staff members who work in the 'Emergency' service.
SELECT staff_id, staff_name
FROM staff
WHERE service = 'emergency';

-- 3. List all weeks where more than 100 patients requested admission in any service.
SELECT DISTINCT week, service
FROM services_weekly
WHERE patients_request > 100;

-- Daily Challenge  Find all patients admitted to 'Surgery' service with a satisfaction score below 70, showing their patient_id, name, age, and satisfaction score.
SELECT patient_id, name, age, satisfaction
FROM patients
WHERE service = 'Surgery' AND satisfaction < 70;






