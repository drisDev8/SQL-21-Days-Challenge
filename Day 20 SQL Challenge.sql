-- Day 20

-- 1. Calculate running total of patients admitted by week for each service.
SELECT service, week, patients_admitted,
SUM(patients_admitted) OVER(PARTITION BY service ORDER BY week) AS running_total
FROM services_weekly
ORDER BY service, week;

-- 2. Find the moving average of patient satisfaction over 4-week periods.
SELECT week, patient_satisfaction, 
AVG(patient_satisfaction) OVER(ORDER BY week ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS moving_avg
FROM services_weekly
ORDER BY week;

-- 3. Show cumulative patient refusals by week across all services.
SELECT week, service, 
SUM(patients_refused) OVER(ORDER BY week) AS cumulative_sum
FROM services_weekly
ORDER BY week, service;

/* Daily Challenge: Create a trend analysis showing for each service and week: week number, patients_admitted, running total of patients admitted (cumulative), 3-week moving 
average of patient satisfaction (current week and 2 prior weeks), and the difference between current week admissions and the service average. Filter for weeks 10-20 only.*/
SELECT service, week, patients_admitted,
-- 1. Running total (cumulative admissions per service)
    SUM(patients_admitted) OVER (PARTITION BY service ORDER BY week) AS cumulative_admissions,
-- 2. 3-week moving average of patient satisfaction
    AVG(patient_satisfaction) OVER (PARTITION BY service ORDER BY week ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_satisfaction_3week,
    -- 3. Difference between current week admissions and service average
    patients_admitted - AVG(patients_admitted) OVER (PARTITION BY service) AS diff_from_service_avg
FROM services_weekly
WHERE week BETWEEN 10 AND 20
ORDER BY service, week;