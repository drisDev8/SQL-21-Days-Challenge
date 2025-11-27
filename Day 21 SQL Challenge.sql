-- Day 21

-- 1. Create a CTE to calculate service statistics, then query from it.
WITH service_stats AS(
SELECT service, SUM(patients_request) total_requested, SUM(patients_admitted) total_admitted, SUM(patients_refused) total_refused,
AVG(patient_satisfaction) AS avg_satisfaction
FROM services_weekly
GROUP BY service
)
SELECT * FROM services_weekly;

-- 2. Use multiple CTEs to break down a complex query into logical steps.
WITH service_stats AS (
    SELECT service,
        SUM(patients_request) AS total_patients_request, SUM(patients_admitted) AS total_patients_admitted,
        SUM(patients_refused) AS total_patients_refused,
        ROUND(AVG(patient_satisfaction), 2) AS average_patient_satisfaction
    FROM services_weekly
    GROUP BY service
),
cte_rates AS (
    SELECT service,
        ROUND(total_patients_admitted / total_patients_request, 2) AS admission_rate,
        ROUND(total_patients_refused / total_patients_request, 2) AS refusion_rate,
        RANK() OVER (ORDER BY total_patients_admitted DESC) AS ranking
    FROM service_stats
)
SELECT * FROM cte_rates;

-- 3. Build a CTE for staff utilization and join it with patient data.
WITH staff_cte AS (
    SELECT service, COUNT(staff_id) AS total_staff
    FROM hospital.staff
    GROUP BY service
),
patient_cte AS (
    SELECT service, COUNT(patient_id) AS total_patients,
        ROUND(AVG(satisfaction), 2) AS average_satisfaction
    FROM hospital.patients
    GROUP BY service
)
SELECT s.service, s.total_staff, p.total_patients, p.average_satisfaction
FROM staff_cte s
JOIN patient_cte p ON s.service = p.service
ORDER BY s.service;




/* Daily Challenge: Create a comprehensive hospital performance dashboard using CTEs. Calculate: 1) Service-level metrics (total admissions, refusals, avg satisfaction), 2) 
Staff metrics per service (total staff, avg weeks present), 3) Patient demographics per service (avg age, count). Then combine all three CTEs to create a final report 
showing service name, all calculated metrics, and an overall performance score (weighted average of admission rate and satisfaction). Order by performance score descending.*/
WITH service_level_metrics AS (
    SELECT service,
        SUM(patients_admitted) AS total_admissions,
        SUM(patients_refused) AS total_refusals,
        AVG(patient_satisfaction) AS avg_satisfaction
    FROM services_weekly
    GROUP BY service
),
staff_metrics AS (
    SELECT service,
        COUNT(DISTINCT staff_id) AS total_staff,
        AVG(present) AS avg_weeks_present
    FROM staff_schedule
    GROUP BY service
),
patient_demographics AS (
    SELECT service,
        AVG(age) AS avg_age,
        COUNT(patient_id) AS total_patients
    FROM patients
    GROUP BY service
)
SELECT s.service, s.total_admissions, s.total_refusals, s.avg_satisfaction,
    st.total_staff, st.avg_weeks_present, p.avg_age, p.total_patients,
    (s.avg_satisfaction * 2) + s.total_admissions AS performance_score
FROM service_level_metrics s
LEFT JOIN staff_metrics st ON s.service = st.service
LEFT JOIN patient_demographics p ON s.service = p.service
ORDER BY performance_score DESC;
