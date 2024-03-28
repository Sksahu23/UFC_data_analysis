-- Find the percentage of title fights
SELECT ROUND(COUNT(*) * 100/
            (SELECT COUNT(*) FROM fight_data) :: NUMERIC,1) || ' %'as sk
FROM fight_data
WHERE title_bout = 'True';
-- 4.4 % 



--Find most accomplished fighter
WITH title_bouts_table AS (
	SELECT *
	FROM fight_data fd JOIN ufc_weight_class wc 
	ON fd.weight_class = wc.weight_class
	WHERE title_bout = 'True')
	
SELECT 
	CASE WHEN winner = 'Red' THEN r_fighter ELSE b_fighter END AS Fighter_Name,
	STRING_AGG(DISTINCT weight_class_name, ', ') AS weight_classes,
	COUNT(*) AS tile_fight_victories
from title_bouts_table
GROUP BY 
	CASE WHEN winner = 'Red' THEN r_fighter ELSE b_fighter END
ORDER BY tile_fight_victories DESC
LIMIT 3;
-- ANS = "Jon Jones" is the most accomplished fighter with 14 UFC title fight wins.



-- Shortest Title fight in UFC history
SELECT r_fighter, b_fighter, total_fight_time_secs, date, weight_class_name
FROM fight_data fd
JOIN ufc_weight_class wc ON fd.weight_class = wc.weight_class
WHERE title_bout = 'TRUE' and total_fight_time_secs = (         
    SELECT MIN(total_fight_time_secs)
    FROM fight_data
	WHERE title_bout = 'TRUE');
/* "Conor McGregor" vs "Jose Aldo" is the Shortest Title Fight in UFC History,
the fight lasted for only 13 secs */



-- Youngest Champion in UFC History
SELECT	
	CASE WHEN winner = 'Red' THEN r_fighter ELSE b_fighter END AS fighter,
	CASE WHEN winner = 'Red' THEN r_age ELSE b_age END AS winner_age
FROM fight_data
WHERE title_bout = 'True' AND no_of_rounds = '5'
ORDER BY winner_age
LIMIT 1;
-- "Jon Jones" is the Youngest Champion in UFC History at Age of 23 yrs

