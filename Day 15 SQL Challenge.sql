-- Day 15
-- 1. Join patients, staff, and staff_schedule to show patient service and staff availability.
SELECT p.service, s.staff_id, s.staff_name, s.role, ss.week, ss.present
FROM patients p 
JOIN staff s ON s.service = p.service
JOIN staff_schedule ss ON ss.staff_id = s.staff_id;

-- 2. Combine services_weekly with staff and staff_schedule for comprehensive service analysis.
SELECT sw.*, s.staff_id, s.staff_name, s.role, ss.week, ss.present
FROM services_weekly sw 
LEFT JOIN staff s ON s.service = sw.service
JOIN staff_schedule ss ON ss.service = sw.service;

-- 3. Create a multi-table report showing patient admissions with staff information.
SELECT p.*, s.staff_id, s.staff_name, s.role
FROM patients p 
LEFT JOIN staff s ON s.service = p.service;

/* Daily Challenge: Create a comprehensive service analysis report for week 20 showing: service name, total patients admitted that week, total patients refused, 
average patient satisfaction, count of staff assigned to service, and count of staff present that week. Order by patients admitted descending.*/
SELECT 
    sw.service,
    SUM(sw.patients_admitted) AS total_admitted,
    SUM(sw.patients_refused) AS total_refused,
    ROUND(AVG(sw.patient_satisfaction),2) AS avg_satisfaction,
    COUNT(DISTINCT ss.staff_id) AS staff_cnt,
    COUNT(DISTINCT CASE 
						WHEN ss.present = 1 THEN  ss.staff_id END) AS staff_present_Week20
FROM services_weekly sw
LEFT JOIN staff_schedule ss ON ss.service = sw.service AND ss.week = 20
WHERE sw.week = 20
GROUP BY sw.service
ORDER BY total_admitted DESC;



