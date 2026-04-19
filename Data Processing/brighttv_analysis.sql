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

--- Data Cleaning And Transformation--------------------------------------------------
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

    CASE 
        WHEN B.Gender IS NULL OR B.Gender = 'None' THEN 'Other'
        ELSE B.Gender
    END AS Gender,

    CASE 
        WHEN B.Race IS NULL OR B.Race = 'None' OR B.Race = ' ' THEN 'other'
        ELSE B.Race
    END AS Race,

    B.Age,

     CASE
        WHEN B.Age <= 12 THEN 'Kids'
        WHEN B.Age BETWEEN 13 AND 19 THEN 'Teenagers'
        WHEN B.Age BETWEEN 20 AND 34 THEN 'Youth'
        WHEN B.Age BETWEEN 35 AND 54 THEN 'Adults'
        WHEN B.Age >= 55 THEN 'Pensioners'
    END AS Age_Group,

    CASE 
        WHEN B.Province IS NULL OR B.Province = 'None' THEN 'Other'
        ELSE B.Province
    END AS Province,

    B.`Social Media Handle` AS Social_Media_Handle,
    
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

--- Total Distinct Users
SELECT COUNT(DISTINCT UserID) AS total_users
FROM workspace.default.brighttv_clean;

--- Total Viewing Minutes
SELECT 
    SUM(Duration_Minutes) AS total_viewing_minutes
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
SELECT Age_Group, 
        COUNT(*) AS views
FROM workspace.default.brighttv_clean
GROUP BY Age_Group
ORDER BY Age_Group;

---Total Viewing Minutes by Race
SELECT Race, COUNT(*) AS total_views
FROM workspace.default.brighttv_clean
GROUP BY Race
ORDER BY total_views DESC;

--- Low Consumption Days
SELECT
    day_name,
    COUNT(*) AS total_views
FROM workspace.default.brighttv_clean
GROUP BY day_name
ORDER BY total_views ASC;

SELECT *
FROM workspace.default.brighttv_clean;
