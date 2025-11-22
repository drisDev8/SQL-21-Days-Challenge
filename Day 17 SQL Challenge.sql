-- Day 17

-- 1. Show each patient with their service's average satisfaction as an additional column.
SELECT p.*, svw.avg_satisfaction
FROM patients p
LEFT JOIN (
    SELECT service, ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction
    FROM services_weekly
    GROUP BY service
) svw
ON p.service = svw.service
ORDER BY p.service, p.patient_id;

-- 2. Create a derived table of service statistics and query from it.
SELECT *
FROM (
    SELECT service, SUM(patients_admitted) AS total_admitted,
        SUM(patients_refused) AS total_refused,
        ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction,
        COUNT(DISTINCT week) AS weeks_reported
    FROM services_weekly
    GROUP BY service
) AS service_stats
WHERE total_admitted > 0
ORDER BY total_admitted DESC;

-- 3. Display staff with their service's total patient count as a calculated field.
SELECT s.*, COALESCE(pt.total_patients, 0) AS total_patients_service
FROM staff s
LEFT JOIN (SELECT service, COUNT(*) AS total_patients
    FROM patients
    GROUP BY service
) pt
ON s.service = pt.service
ORDER BY pt.total_patients DESC, s.staff_name;

/* Daily Challenge: Create a report showing each service with: service name, total patients admitted, the difference between their total admissions and the average admissions
across all services, and a rank indicator ('Above Average', 'Average', 'Below Average'). Order by total patients admitted descending.*/

SELECT service, total_admitted, ROUND(total_admitted - overall_avg, 2) AS diff_from_avg,
    CASE
        WHEN total_admitted > overall_avg THEN 'Above Average'
        WHEN total_admitted = overall_avg THEN 'Average'
        ELSE 'Below Average'
    END AS rank_indicator
FROM (
    SELECT service, SUM(patients_admitted) AS total_admitted,
        AVG(SUM(patients_admitted)) OVER() AS overall_avg
    FROM services_weekly
    GROUP BY service
) sub
ORDER BY total_admitted DESC;
