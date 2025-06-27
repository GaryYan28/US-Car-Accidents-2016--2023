-- TOTAL ACCIDENTS
SELECT COUNT(DISTINCT ID)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS;

-- AVERAGE SEVERITY
SELECT ROUND(AVG(severity), 2),
    STDDEV(severity)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS;

-- ACCIDENTS PER DAY

-- FIRST ACCIDENT Feb. 08, 2016
SELECT *
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
ORDER BY start_time ASC
LIMIT 100;

-- LAST ACCIDENT Mar. 31, 2023
SELECT start_time
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
ORDER BY start_time DESC
LIMIT 1;

-- Accidents per month
SELECT 
    YEAR(start_time),
    MONTH(start_time),
    COUNT(*)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY YEAR(start_time), MONTH(start_time)
ORDER BY YEAR(start_time), MONTH(start_time) ASC;

-- 2609 days are tracked, 2745 accidents occur per day
SELECT ROUND(COUNT(DISTINCT ID) / 2609, 2) AS accidents_per_day,
    AVG(severity) AS average_severity
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS;

-- If we want to take the average from June 2016 onwards, we get 2853 accidents per day
SELECT ROUND(COUNT(DISTINCT ID) / 2465, 2) AS accidents_per_day,
    AVG(severity) AS average_severity
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE start_time >= '2016-07-01';

-- Day of the week breakdown
SELECT 
    DAYNAME(start_time) AS day_of_the_week, 
    COUNT(*),
    AVG(severity)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY day_of_the_week
ORDER BY MIN(DAYOFWEEK(start_time));

WITH daily_counts AS (
    SELECT 
        DATE(start_time) AS accident_date,
        DAYNAME(start_time) AS day_name,
        SUM(severity) AS severity_total,
        COUNT(*) AS accidents_total
    FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
    WHERE start_time >= '2016-06-01'
    GROUP BY 1, 2
)
SELECT 
    day_name AS "Day",
    ROUND(AVG(accidents_total), 2) AS avg_accidents_per_day,
    ROUND(AVG(severity_total) / AVG(accidents_total), 2) AS average_severity
FROM daily_counts
GROUP BY day_name
ORDER BY 
    CASE day_name
        WHEN 'Mon' THEN 1
        WHEN 'Tue' THEN 2
        WHEN 'Wed' THEN 3
        WHEN 'Thu' THEN 4
        WHEN 'Fri' THEN 5
        WHEN 'Sat' THEN 6
        WHEN 'Sun' THEN 7
    END;

-- Seasonal trends
SELECT 
    CASE 
        WHEN MONTH(start_time) IN ('12', '1', '2') THEN 'Winter'
        WHEN MONTH(start_time) IN ('3', '4', '5') THEN 'Spring'
        WHEN MONTH(start_time) IN ('6', '7', '8') THEN 'Summer'
        WHEN MONTH(start_time) IN ('9', '10', '11') THEN 'Fall'
    END AS season,
    COUNT(*) AS accidents,
    ROUND(AVG(severity), 2) AS average_severity
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY season;

WITH daily_counts AS (
    SELECT 
        DATE(start_time) AS accident_date,
        MONTH(start_time) AS month_name,
        SUM(severity) AS severity_total,
        COUNT(*) AS accidents_total
    FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
    WHERE start_time >= '2016-06-01'
    GROUP BY 1, 2
)
SELECT 
    CASE
        WHEN month_name IN ('12', '1', '2') THEN 'Winter'
        WHEN month_name IN ('3', '4', '5') THEN 'Spring'
        WHEN month_name IN ('6', '7', '8') THEN 'Summer'
        WHEN month_name IN ('9', '10', '11') THEN 'Fall'
    END AS season,
    ROUND(AVG(accidents_total), 2) AS avg_accidents_per_day,
    ROUND(AVG(severity_total) / AVG(accidents_total), 2) AS average_severity
FROM daily_counts
GROUP BY season
ORDER BY 
    CASE season
        WHEN 'Winter' THEN 1
        WHEN 'Spring' THEN 2
        WHEN 'Summer' THEN 3
        WHEN 'Fall' THEN 4
    END; 


-- WEATHER EXPLORATION

SELECT weather_condition, count(*)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE weather_condition LIKE '%Fair%'
GROUP BY weather_condition
ORDER BY count(*) DESC;

SELECT weather_condition, COUNT(*)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY weather_condition
ORDER BY count(*) DESC;

-- Total accidents and severity based on weather
-- Varied descriptions of weather, trying to group similar descriptions like 'Fog' or 'Haze' 
SELECT
    CASE
        WHEN weather_condition LIKE '%Thunder%' OR weather_condition LIKE '%T-Storm%' THEN 'Thunderstorms'
        WHEN weather_condition LIKE '%Rain%' OR weather_condition LIKE '%Drizzle%' THEN 'Rainy'
        WHEN weather_condition LIKE '%Snow%' OR weather_condition LIKE '%Wintry%' THEN 'Snowy'
        WHEN weather_condition LIKE '%Fog%' OR weather_condition LIKE '%Haze%' OR weather_condition LIKE '%Mist%' THEN 'Foggy'
        WHEN weather_condition LIKE '%Clear%' THEN 'Clear'
        WHEN weather_condition LIKE '%Fair%' THEN 'Fair'
        WHEN weather_condition LIKE '%Cloud%' OR weather_condition LIKE '%Overcast%' THEN 'Cloudy'
    END AS weather,
    COUNT(*) AS number_of_accidents,
    COUNT(CASE WHEN severity = 1 THEN 1 END) AS "severity 1",
    COUNT(CASE WHEN severity = 2 THEN 1 END) AS "severity 2",
    COUNT(CASE WHEN severity = 3 THEN 1 END) AS "severity 3",
    COUNT(CASE WHEN severity = 4 THEN 1 END) AS "severity 4",
    ROUND(("severity 3" + "severity 4") / number_of_accidents * 100, 2) AS "High Severity %",
    ROUND(AVG(severity), 2) AS average_severity
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY weather
ORDER BY average_severity DESC;

-- Rain exploration
SELECT weather_condition,
    COUNT(*),
    AVG(severity)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE weather_condition LIKE '%Rain%'
GROUP BY weather_condition
HAVING COUNT(*) > 1000
ORDER BY AVG(severity) DESC;

-- Severity of accidents that occur during the day vs night
SELECT sunrise_sunset,
    COUNT(*) AS "total_accidents",
    COUNT(CASE WHEN severity = 1 THEN 1 END) AS "severity 1",
    COUNT(CASE WHEN severity = 2 THEN 1 END) AS "severity 2",
    COUNT(CASE WHEN severity = 3 THEN 1 END) AS "severity 3",
    COUNT(CASE WHEN severity = 4 THEN 1 END) AS "severity 4",
    ROUND(("severity 3" + "severity 4") / "total_accidents" * 100, 2) AS high_severity_percentage,
    AVG(severity) AS average_severity
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE sunrise_sunset IS NOT NULL
GROUP BY sunrise_sunset;

-- VISIBILITY EXPLORATION

-- Max visibility 140 miles but not a lot of accidents about 10 miles, lowest is 0, there are some accidents where visibility is not available
SELECT visibility
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE visibility IS NOT NULL
ORDER BY visibility DESC
LIMIT 100;

SELECT COUNT(*)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE visibility >= 10.0;

SELECT 
    CASE
        WHEN visibility IS NULL THEN 'Not Available'
        WHEN visibility < 1 THEN 'Less than 1 mile'
        WHEN visibility >= 1 AND visibility < 2 THEN '1-1.9 miles'
        WHEN visibility >= 2 AND visibility < 5 THEN '2-4.9 miles'
        WHEN visibility >= 5 AND visibility < 10 THEN '5-9.9 miles'
        WHEN visibility >= 10 THEN '10+ miles'
    END AS road_visibility,
    COUNT(*) AS total_accidents,
    COUNT(CASE WHEN severity = 1 THEN 1 END) AS severity_1,
    COUNT(CASE WHEN severity = 2 THEN 1 END) AS severity_2,
    COUNT(CASE WHEN severity = 3 THEN 1 END) AS severity_3,
    COUNT(CASE WHEN severity = 4 THEN 1 END) AS severity_4,
    ROUND((severity_3 + severity_4) / total_accidents * 100, 2) AS high_severity_percentage,
    ROUND(AVG(severity), 2) AS average_severity
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY road_visibility
ORDER BY 
    CASE road_visibility
        WHEN 'Less than 1 mile' THEN 1
        WHEN '1-1.9 miles' THEN 2
        WHEN '2-4.9 miles' THEN 3
        WHEN '5-9.9 miles' THEN 4
        WHEN '10+ miles' THEN 5
    END;

-- SPEED EXPLORATION

-- See if accidents on highways are more severe
SELECT 
    CASE
        WHEN street LIKE '%Highway%' OR street LIKE '%I-%' OR street LIKE '%US-%' OR street LIKE '%Hwy%'OR street LIKE '%Interstate%' THEN 'Highway'
        ELSE 'Local'
    END AS street_type,
    COUNT(*) AS number_of_accidents,
    ROUND(AVG(severity), 2) AS average_severity
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY street_type;

SELECT traffic_calming,
    COUNT(*) AS number_of_accidents,
    ROUND(AVG(severity), 2) AS average_severity
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY traffic_calming;
    
-- Severity breakdown
SELECT severity, count(*)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY severity
ORDER BY severity ASC;

-- Most accident prone states
SELECT state,
    COUNT(*)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY state
ORDER BY COUNT(*) DESC
LIMIT 10;

SELECT COUNT(*),
    AVG(severity)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE street LIKE '%Highway%' 
    OR street LIKE '%I-%' 
    OR street LIKE '%US-%'
    OR street LIKE '%Hwy%'
    OR street LIKE '%Interstate%'
LIMIT 1000;

SELECT weather_condition, COUNT(*), AVG(severity)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE weather_condition LIKE '%Snow%'
GROUP BY weather_condition
LIMIT 100;

SELECT state,
    COUNT(*) AS total_accidents,
    ROUND(AVG(severity), 2),
    ROUND((COUNT(CASE WHEN severity = 3 THEN 1 END) + COUNT(CASE WHEN severity = 4 THEN 1 END)) / total_accidents * 100, 2) AS "high_severity_percent"
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY state
ORDER BY "high_severity_percent" DESC;

-- What times do most accidents occur on weekdays and weekends
-- WEEKDAYS
SELECT HOUR(start_time) AS accident_time,
    COUNT(*) AS number_of_accidents
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE DAYOFWEEK(start_time) IN (1, 2, 3, 4, 5)
GROUP BY HOUR(start_time)
ORDER BY COUNT(*) DESC;

-- WEEKENDS
SELECT HOUR(start_time) AS accident_time,
    COUNT(*) AS number_of_accidents
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE DAYOFWEEK(start_time) NOT IN (1, 2, 3, 4, 5)
GROUP BY HOUR(start_time)
ORDER BY COUNT(*) DESC;

SELECT sunrise_sunset,
    AVG(severity)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY sunrise_sunset;
