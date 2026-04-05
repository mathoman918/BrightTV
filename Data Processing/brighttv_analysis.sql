--- DATA EXPLORATION
--- Preview the tables
SELECT *
FROM workspace.default.Viewership
LIMIT 10;

SELECT *
FROM workspace.default.user_profiles
LIMIT 10;

SELECT *
FROM workspace.default.viewership AS A
LEFT JOIN workspace.default.user_profiles AS B
ON A.UserID0 = B.UserID
LIMIT 10;

--- Data Cleaning
--------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE workspace.default.brighttv_clean AS
SELECT
    A.UserID0 AS UserID,
    A.Channel2 AS Channel,
    
    A.RecordDate2 + INTERVAL 2 HOURS AS RecordDate_SA,
    
    A.`Duration 2` AS Duration,
    
    -- Convert duration to minutes
    (HOUR(A.`Duration 2`) * 60) + MINUTE(A.`Duration 2`) AS Duration_Minutes,
    
    B.Name,
    B.Surname,
    B.Email,
    B.Gender,
    B.Race,
    B.Age,
    B.Province,
    
    YEAR(A.RecordDate2 + INTERVAL 2 HOURS) AS year,
    MONTH(A.RecordDate2 + INTERVAL 2 HOURS) AS month,
    DAY(A.RecordDate2 + INTERVAL 2 HOURS) AS day,
    
    DATE_FORMAT(A.RecordDate2 + INTERVAL 2 HOURS, 'MMMM') AS month_name,
    DATE_FORMAT(A.RecordDate2 + INTERVAL 2 HOURS, 'EEEE') AS day_name,
    
    HOUR(A.RecordDate2 + INTERVAL 2 HOURS) AS hour
FROM workspace.default.viewership AS A
LEFT JOIN workspace.default.user_profiles AS B
ON A.UserID0 = B.UserID;
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

--- Total Consumption
SELECT
    COUNT(*) AS total_sessions
FROM workspace.default.brighttv_clean;

--- Consumption by Day
SELECT
    day_name,
    COUNT(*) AS total_views
FROM workspace.default.brighttv_clean
GROUP BY day_name
ORDER BY total_views DESC;

--- Consumption by Hour
SELECT
    hour,
    COUNT(*) AS total_views
FROM workspace.default.brighttv_clean
GROUP BY hour
ORDER BY hour;

--- Most Watched Channels
SELECT
    Channel,
    COUNT(*) AS total_views
FROM workspace.default.brighttv_clean
GROUP BY Channel
ORDER BY total_views DESC;

--- Consumption by Province
SELECT
    Province,
    COUNT(*) AS total_views
FROM workspace.default.brighttv_clean
GROUP BY Province
ORDER BY total_views DESC;

--- Consumption by Gender
SELECT
    Gender,
    COUNT(*) AS total_views
FROM workspace.default.brighttv_clean
GROUP BY Gender;

--- Consumption by Age
SELECT
    Age,
    COUNT(*) AS total_views
FROM workspace.default.brighttv_clean
GROUP BY Age
ORDER BY Age;

--- Low Consumption Days
SELECT
    day_name,
    COUNT(*) AS total_views
FROM workspace.default.brighttv_clean
GROUP BY day_name
ORDER BY total_views ASC;

SELECT *
FROM workspace.default.brighttv_clean;
