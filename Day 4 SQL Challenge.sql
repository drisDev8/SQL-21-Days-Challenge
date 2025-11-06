/* DAY 4: Practice Questions */
-- 1. Display the first 5 patients from the patients table.
SELECT * 
FROM patients
LIMIT 5;

-- 2. Show patients 11-20 using OFFSET.
SELECT *
FROM patients
LIMIT 10
OFFSET 10;

-- 3. Get the 10 most recent patient admissions based on arrival_date.
SELECT *
FROM patients
ORDER BY arrival_date DESC
LIMIT 10;

/* Daily Challenge: Find the 3rd to 7th highest patient satisfaction scores from the patients table, showing patient_id, name, service, and satisfaction. 
Display only these 5 records. */

SELECT patient_id, name, service, satisfaction
FROM patients
ORDER BY satisfaction DESC
LIMIT 5
OFFSET 2;



