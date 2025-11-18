-- Day 14
-- 1. Show all staff members and their schedule information (including those with no schedule entries).
SELECT s.*, ss.week, ss.present
FROM staff s 
LEFT JOIN staff_schedule ss ON ss.staff_id = s.staff_id;

-- 2. List all services from services_weekly and their corresponding staff (show services even if no staff assigned).
SELECT sw.service, s.staff_id, s.staff_name, s.role
FROM services_weekly sw 
LEFT JOIN staff s ON s.service = sw.service;

-- 3. Display all patients and their service's weekly statistics (if available).
SELECT p.*, sw.*
FROM patients p 
LEFT JOIN services_weekly sw ON sw.service = p.service;

/* Daily Challenge: Create a staff utilisation report showing all staff members (staff_id, staff_name, role, service) and the count of weeks they were present
(from staff_schedule). Include staff members even if they have no schedule records. Order by weeks present descending.*/
SELECT s.staff_id, s.staff_name, s.role, s.service,
COUNT(ss.week) AS weeks_present
FROM staff AS s
LEFT JOIN staff_schedule AS ss ON ss.staff_id = s.staff_id
GROUP BY s.staff_id, s.staff_name, s.role, s.service
ORDER BY SUM(ss.present) DESC;
