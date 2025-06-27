-- BACKING UP DATA
CREATE TABLE ALL_ACCIDENTS AS
SELECT * FROM US_ACCIDENTS.PUBLIC.ORIGINAL_ALL_ACCIDENTS;

-- Finding duplicate entries 565k entries
SELECT COUNT(*) 
FROM US_ACCIDENTS.PUBLIC.ORIGINAL_ALL_ACCIDENTS
WHERE id IN (
    SELECT id FROM (
        SELECT id,
               ROW_NUMBER() OVER(
                   PARTITION BY description, start_time, street
                   ORDER BY id
               ) AS rn
        FROM US_ACCIDENTS.PUBLIC.ORIGINAL_ALL_ACCIDENTS
    ) 
    WHERE rn > 1
);

-- Deleting duplicate entries
DELETE FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
WHERE id IN (
    SELECT id FROM (
        SELECT id,
               ROW_NUMBER() OVER(
                   PARTITION BY description, start_time, street
                   ORDER BY id
               ) AS rn
        FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
    ) 
    WHERE rn > 1
);

-- Have entries from Jan. 2016 but data collection supposed to have began Feb. 
SELECT *
FROM US_ACCIDENTS.PUBLIC.ORIGINAL_ALL_ACCIDENTS
ORDER BY start_time ASC
LIMIT 100;

DELETE FROM ALL_ACCIDENTS
WHERE start_time < '2016-02-01';

-- May have taken to around June 2016 for data collection to ramp up
SELECT 
    YEAR(start_time),
    MONTH(start_time),
    COUNT(*)
FROM US_ACCIDENTS.PUBLIC.ALL_ACCIDENTS
GROUP BY YEAR(start_time), MONTH(start_time)
ORDER BY YEAR(start_time), MONTH(start_time) ASC;