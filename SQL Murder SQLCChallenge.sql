-- SQL Murder Mystery: “Who Killed the CEO?
CREATE SCHEMA MurderSQL;
-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    role VARCHAR(50)
);

INSERT INTO employees VALUES
(1, 'Alice Johnson', 'Engineering', 'Software Engineer'),
(2, 'Bob Smith', 'HR', 'HR Manager'),
(3, 'Clara Lee', 'Finance', 'Accountant'),
(4, 'David Kumar', 'Engineering', 'DevOps Engineer'),
(5, 'Eva Brown', 'Marketing', 'Marketing Lead'),
(6, 'Frank Li', 'Engineering', 'QA Engineer'),
(7, 'Grace Tan', 'Finance', 'CFO'),
(8, 'Henry Wu', 'Engineering', 'CTO'),
(9, 'Isla Patel', 'Support', 'Customer Support'),
(10, 'Jack Chen', 'HR', 'Recruiter');

-- Keycard Logs Table
CREATE TABLE keycard_logs (
    log_id INT PRIMARY KEY,
    employee_id INT,
    room VARCHAR(50),
    entry_time TIMESTAMP,
    exit_time TIMESTAMP
);

INSERT INTO keycard_logs VALUES
(1, 1, 'Office', '2025-10-15 08:00', '2025-10-15 12:00'),
(2, 2, 'HR Office', '2025-10-15 08:30', '2025-10-15 17:00'),
(3, 3, 'Finance Office', '2025-10-15 08:45', '2025-10-15 12:30'),
(4, 4, 'Server Room', '2025-10-15 08:50', '2025-10-15 09:10'),
(5, 5, 'Marketing Office', '2025-10-15 09:00', '2025-10-15 17:30'),
(6, 6, 'Office', '2025-10-15 08:30', '2025-10-15 12:30'),
(7, 7, 'Finance Office', '2025-10-15 08:00', '2025-10-15 18:00'),
(8, 8, 'Server Room', '2025-10-15 08:40', '2025-10-15 09:05'),
(9, 9, 'Support Office', '2025-10-15 08:30', '2025-10-15 16:30'),
(10, 10, 'HR Office', '2025-10-15 09:00', '2025-10-15 17:00'),
(11, 4, 'CEO Office', '2025-10-15 20:50', '2025-10-15 21:00'); -- killer

-- Calls Table
CREATE TABLE calls (
    call_id INT PRIMARY KEY,
    caller_id INT,
    receiver_id INT,
    call_time TIMESTAMP,
    duration_sec INT
);

INSERT INTO calls VALUES
(1, 4, 1, '2025-10-15 20:55', 45),
(2, 5, 1, '2025-10-15 19:30', 120),
(3, 3, 7, '2025-10-15 14:00', 60),
(4, 2, 10, '2025-10-15 16:30', 30),
(5, 4, 7, '2025-10-15 20:40', 90);

-- Alibis Table
CREATE TABLE alibis (
    alibi_id INT PRIMARY KEY,
    employee_id INT,
    claimed_location VARCHAR(50),
    claim_time TIMESTAMP
);

INSERT INTO alibis VALUES
(1, 1, 'Office', '2025-10-15 20:50'),
(2, 4, 'Server Room', '2025-10-15 20:50'), -- false alibi
(3, 5, 'Marketing Office', '2025-10-15 20:50'),
(4, 6, 'Office', '2025-10-15 20:50');

-- Evidence Table
CREATE TABLE evidence (
    evidence_id INT PRIMARY KEY,
    room VARCHAR(50),
    description VARCHAR(255),
    found_time TIMESTAMP
);

INSERT INTO evidence VALUES
(1, 'CEO Office', 'Fingerprint on desk', '2025-10-15 21:05'),
(2, 'CEO Office', 'Keycard swipe logs mismatch', '2025-10-15 21:10'),
(3, 'Server Room', 'Unusual access pattern', '2025-10-15 21:15');



-- Murder Report: The CEO of TechNova Inc. has been found dead in their office on October 15, 2025, at 9:00 PM.

-- Investigation Step 1: Identifying where and when the crime happened.
SELECT room AS crime_location, entry_time
FROM keycard_logs
WHERE room = 'CEO Office'
ORDER BY entry_time;

-- Investigation Step 2: Analyze Who Accessed Critical Areas at the Time
SELECT e.employee_id, e.name, k.room, k.entry_time, k.exit_time
FROM employees AS e
JOIN keycard_logs AS k ON e.employee_id = k.employee_id
WHERE room = 'CEO Office' AND
entry_time BETWEEN '2025-10-15 20:00:00' AND '2025-10-15 21:00:00';

-- Investigation Step 3: Cross-Check Alibis with Actual Logs
SELECT e.employee_id, e.name, a.claimed_location, k.room AS actual_room, a.claim_time, k.entry_time, k.exit_time,
CASE
WHEN k.room IS NULL THEN 'no log available for claim time'
WHEN k.room = a.claimed_location THEN 'Match'
ELSE 'Mismatch'
END AS status
FROM employees e
JOIN alibis a ON e.employee_id = a.employee_id
LEFT JOIN keycard_logs k ON e.employee_id = k.employee_id
AND a.claim_time BETWEEN k.entry_time AND k.exit_time
ORDER BY employee_id;

-- Investigation Step 4: Investigate Suspicious Calls Made Around the Time
SELECT c.call_id, e1.name AS caller_name, e2.name AS receiver_name, c.call_time, c.duration_sec
FROM calls AS c
JOIN employees AS e1
ON c.caller_id = e1.employee_id
JOIN employees AS e2 ON c.receiver_id = e2.employee_id
WHERE call_time BETWEEN '2025-10-15 20:00:00' AND '2025-10-15 21:00:00';

-- Investigation Step 5: Match Evidence with Movements and Claims
SELECT ev.evidence_id, ev.room AS evidence_room, ev.description,
TIME(ev.found_time) AS found_time_only, e.name, k.room AS actual_location,
TIME(k.entry_time) AS entry_time_only, a.claimed_location,
TIME(a.claim_time) AS claim_time_only,
CASE
WHEN a.claimed_location IS NULL THEN 'alibi not available'
WHEN a.claimed_location = k.room THEN 'Alibi match'
ELSE 'Alibi Mismatch'
END AS Alibi_status
FROM evidence ev
JOIN keycard_logs k ON ev.room = k.room
JOIN employees e ON k.employee_id = e.employee_id
LEFT JOIN alibis a ON e.employee_id = a.employee_id;

-- Investigation Step 6: Combine All Findings to Identify the Killer
SELECT emp.name AS suspect, k.room AS actual_location,
TIME(k.entry_time) AS entry_time,
TIME(k.exit_time) AS exit_time, a.claimed_location,
TIME(a.claim_time) AS claim_time,
evi.room AS evidence_room,
evi.description AS evidence_found,
TIME(evi.found_time) AS found_time,
CASE
WHEN a.claimed_location IS NULL THEN 'Alibi not available'
WHEN a.claimed_location = k.room THEN 'Alibi match'
ELSE 'Alibi mismatch'
END AS alibi_status
FROM employees emp
JOIN keycard_logs k ON emp.employee_id = k.employee_id
JOIN evidence evi ON evi.room = k.room
AND DATE(evi.found_time) = DATE(k.entry_time)
LEFT JOIN alibis a ON a.employee_id = emp.employee_id
AND DATE(a.claim_time) = DATE(k.entry_time)
WHERE evi.room = 'CEO Office'
ORDER BY evi.found_time, emp.name;
