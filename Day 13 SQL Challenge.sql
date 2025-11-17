-- Day 17
-- 1. Join patients and staff based on their common service field (show patient and staff who work in same service).
SELECT p.patient_id,
    p.name AS patient_name,
    p.service AS patient_service,
    s.staff_id,
    s.staff_name,
    s.service AS staff_service
FROM patients p
JOIN staff s ON s.service = p.service; 

-- 2. Join services_weekly with staff to show weekly service data with staff information.
SELECT sw.week, s.staff_id, s.staff_name, s.role, s.service AS staff_service
FROM services_weekly sw 
JOIN staff s ON sw.service = s.service;

-- 3. Create a report showing patient information along with staff assigned to their service.
SELECT p.*,
    s.staff_id,
    s.staff_name,
    s.role
FROM patients p 
JOIN staff s ON s.service = p.service ;

/* Daily Challenge: Create a comprehensive report showing patient_id, patient name, age, service, and the total number of staff members available in their service. 
Only include patients from services that have more than 5 staff members. Order by number of staff descending, then by patient name.*/
SELECT p.patient_id, p.name, p.age, p.service, COUNT(s.staff_id) AS total_staff
FROM patients p 
JOIN staff s ON s.service = p.service 
GROUP BY p.patient_id, p.name, p.age, p.service
HAVING COUNT(s.staff_id) > 5
ORDER BY COUNT(s.staff_id) DESC, p.name;


