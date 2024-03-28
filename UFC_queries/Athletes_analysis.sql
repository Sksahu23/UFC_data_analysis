-- list of undefeated fighters
WITH all_fighters AS (
    SELECT r_fighter AS fighter, weight_class_name, r_losses AS loss, r_wins AS wins
    FROM fight_data fd JOIN ufc_weight_class wc ON fd.weight_class = wc.weight_class 
    UNION
    SELECT b_fighter AS fighter, weight_class_name, b_losses AS loss, b_wins AS wins
    FROM fight_data fd JOIN ufc_weight_class wc ON fd.weight_class = wc.weight_class 
)
SELECT fighter, 
	STRING_AGG(DISTINCT weight_class_name, ', ') AS weight_classes,
	MAX(wins) as wins, MAX(loss) loss
FROM all_fighters
WHERE loss = 0
GROUP BY fighter
ORDER BY wins DESC
LIMIT 10;



-- Find fighter with Most wins in the UFC
SELECT winner_name, COUNT(*) AS no_of_wins
FROM(SELECT *,
	CASE WHEN winner = 'Red' THEN R_fighter ELSE B_fighter END AS winner_name
FROM fight_data) AS winner_fighter_data
GROUP BY winner_name
ORDER BY no_of_wins DESC
LIMIT 1;



-- Shortest fight in UFC history
SELECT r_fighter, b_fighter, total_fight_time_secs, date
FROM fight_data
WHERE total_fight_time_secs = (
    SELECT MIN(total_fight_time_secs)
    FROM fight_data);
/* "Jorge Masvidal" vs "Ben ASkren" is the Shortest Fight in UFC History,
as the fight lasted for only 5 secs. */



-- Calculate the wins by Age
WITH wins_by_age AS (
    SELECT 
        CASE WHEN Winner = 'Blue' THEN B_age ELSE R_age END AS age,
        COUNT(*) AS wins
    FROM fight_data
    GROUP BY CASE WHEN Winner = 'Blue' THEN B_age ELSE R_age END)
		
SELECT age,SUM(wins) AS total_wins
FROM wins_by_age
GROUP BY age
ORDER BY total_wins DESC;



-- Average height and reach of the fighers per divisions
SELECT wc.weight_class_name,
       ROUND(CAST(AVG(fd.b_height_cms) AS NUMERIC), 2) AS avg_height_cm,
       ROUND(CAST(AVG(fd.B_Reach_cms) AS NUMERIC), 2) AS avg_reach_cm
FROM fight_data fd
INNER JOIN ufc_weight_class wc ON fd.weight_class = wc.weight_class
GROUP BY wc.weight_class_name
ORDER BY avg_height_cm DESC;



-- Fighter with longest reach
WITH all_fighters AS (
    SELECT r_fighter AS fighter,weight_class_name, r_reach_cms as reach, r_height_cms as height
	FROM fight_data fd JOIN ufc_weight_class wc on fd.weight_class = wc.weight_class 
    UNION
    SELECT b_fighter AS fighter,weight_class_name, b_reach_cms as reach, b_height_cms as height
	FROM fight_data fd JOIN ufc_weight_class wc on fd.weight_class = wc.weight_class 
)
SELECT fighter, weight_class_name, reach, height  
FROM all_fighters
ORDER BY reach DESC
LIMIT 1;



-- Find top 10 Fighter that fought longest in the octagon in hrs?
WITH all_fighters AS (
    SELECT r_fighter AS fighter,weight_class_name, total_fight_time_secs 
	FROM fight_data fd JOIN ufc_weight_class wc on fd.weight_class = wc.weight_class 
    UNION ALL
    SELECT b_fighter AS fighter,weight_class_name, total_fight_time_secs 
	FROM fight_data fd JOIN ufc_weight_class wc on fd.weight_class = wc.weight_class 
)
SELECT fighter,
	CAST(SUM(total_fight_time_secs) / 3600 AS NUMERIC(10, 2)) AS total_fight_time_hrs, 
	STRING_AGG(DISTINCT weight_class_name, ', ') AS weight_classes
FROM all_fighters
WHERE all_fighters IS NOT NULL 
GROUP BY fighter
ORDER BY total_fight_time_hrs DESC
LIMIT 10;

