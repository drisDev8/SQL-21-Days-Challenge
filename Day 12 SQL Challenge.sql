-- Day 12
-- 1. Find all weeks in services_weekly where no special event occurred.
SELECT DISTINCT week
FROM services_weekly
WHERE EVENT IS NOT NULL 
OR TRIM(event) = ' ' 
OR LOWER(TRIM(event)) = 'none';

-- 2. Count how many records have null or empty event values.
SELECT COUNT(event) AS event_cnt
FROM services_weekly
WHERE event IS NULL 
OR TRIM(event) = ' ' 
OR LOWER(TRIM(event)) = 'none';

-- 3. List all services that had at least one week with a special event.
SELECT DISTINCT service
FROM services_weekly
WHERE event IS NOT NULL AND event <> ' '; 

/* Daily Challenge: Analyze the event impact by comparing weeks with events vs weeks without events. Show: event status ('With Event' or 'No Event'), 
count of weeks, average patient satisfaction, and average staff morale. Order by average patient satisfaction descending. */
SELECT
CASE
	WHEN event IS NULL OR TRIM(event) = ' ' OR LOWER(TRIM(event)) = 'none' THEN 'Without Event'
    ELSE 'With Event'
    END AS Event_status,
COUNT(week) AS week_cnt, 
ROUND(AVG(patient_satisfaction),2) AS avg_satisfaction, 
ROUND(AVG(staff_morale),2) AS avg_morale
FROM services_weekly
GROUP BY Event_status
ORDER BY avg_satisfaction DESC;







