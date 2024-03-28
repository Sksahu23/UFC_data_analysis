SELECT * 
FROM fight_data;


-- Finding total no. of fighters
SELECT COUNT(DISTINCT fighter_name) AS Total_UFC_Athletes
FROM (
    SELECT R_fighter AS fighter_name FROM fight_data
    UNION
    SELECT B_fighter AS fighter_name FROM fight_data
) AS combined_fighters;
-- Ans = 1747



-- Calculate total no of athlets by gender
SELECT gender,COUNT(fighter) AS fighter_per_gender FROM(
SELECT r_fighter AS fighter,gender FROM fight_data
UNION
SELECT b_fighter AS fighter,gender FROM fight_data)
AS fighter_gender
GROUP BY gender
ORDER BY fighter_per_gender DESC;



--Count the number of fights per weight class
SELECT wc.weight_class_name, COUNT(*) AS num_fights
FROM fight_data fd
JOIN ufc_weight_class wc
ON fd.weight_class = wc.weight_class
GROUP BY wc.weight_class_name
ORDER BY num_fights DESC;
/* Most number of fightes happens in Lightweight division and least amount
of fights happens in women's Featherweight division */



-- Find win percentage of both the sides(Red, Blue)
SELECT winner,ROUND(count(*) *100 /
            (SELECT count(*) FROM fight_data):: NUMERIC,2) || ' %'as win_percentage
FROM fight_data
GROUP BY winner;



/*we will be deleting all the rows with 4 rounds as in the ufc there are no 4 rounds fights
only 3 and 5 rounds fights*/
DELETE FROM fight_data
WHERE no_of_rounds=4;



-- Calculate Average time in mins for 3 & 5 rounds fight
SELECT no_of_rounds,
       ROUND(CAST(AVG(total_fight_time_secs / 60.0) AS numeric), 2) AS avg_fight_time_min
FROM fight_data
WHERE total_fight_time_secs IS NOT NULL
GROUP BY no_of_rounds;



--Find the average age of winners and losers:
SELECT
    winner_avg_age,
    loser_avg_age
FROM (
    SELECT
        ROUND(AVG(CASE WHEN Winner = 'Red' THEN R_age ELSE B_age END), 1) AS winner_avg_age,
        ROUND(AVG(CASE WHEN Winner = 'Blue' THEN R_age ELSE B_age END), 1) AS loser_avg_age
    FROM fight_data
) AS avg_age_data;



-- Determine the number of fights per country
SELECT 
	country_name, 
	COUNT(*) AS fights_per_country
FROM fight_data fd
JOIN ufc_country uc ON fd.country_code = uc.country_code
GROUP BY country_name
ORDER BY fights_per_country DESC
LIMIT 5;



-- Fights per Event
SELECT date,COUNT(*) AS fights_per_date 
FROM fight_data
GROUP BY date
ORDER BY fights_per_date DESC;

--Fights per month
SELECT TO_CHAR(date,'MONTH') AS MONTH,
	COUNT(*) AS fights
FROM fight_data
GROUP BY MONTH
ORDER BY fights DESC;

-- Fights per year
SELECT EXTRACT(YEAR FROM date) AS YEAR,
	COUNT(*) AS fights
FROM fight_data
GROUP BY YEAR
ORDER BY YEAR;



--Calculate the percentage of fights won by each stance (Orthodox, Southpaw, Switch)
SELECT 
    stance,
    ROUND((CAST(wins AS NUMERIC) / total_fights) * 100, 2) || '%' AS win_percentage
FROM (
    SELECT 
        'Orthodox' AS stance,
        SUM(CASE WHEN Winner = 'Red' AND R_Stance = 'Orthodox' THEN 1
                 WHEN Winner = 'Blue' AND B_Stance = 'Orthodox' THEN 1
                 ELSE 0 END) AS wins,
        SUM(CASE WHEN R_Stance = 'Orthodox' OR B_Stance = 'Orthodox' THEN 1 ELSE 0 END) AS total_fights
    FROM fight_data
    
    UNION ALL
    
    SELECT 
        'Southpaw' AS stance,
        SUM(CASE WHEN Winner = 'Red' AND R_Stance = 'Southpaw' THEN 1
                 WHEN Winner = 'Blue' AND B_Stance = 'Southpaw' THEN 1
                 ELSE 0 END) AS wins,
        SUM(CASE WHEN R_Stance = 'Southpaw' OR B_Stance = 'Southpaw' THEN 1 ELSE 0 END) AS total_fights
    FROM fight_data
    
    UNION ALL
    
    SELECT 
        'Switch' AS stance,
        SUM(CASE WHEN Winner = 'Red' AND R_Stance = 'Switch' THEN 1
                 WHEN Winner = 'Blue' AND B_Stance = 'Switch' THEN 1
                 ELSE 0 END) AS wins,
        SUM(CASE WHEN R_Stance = 'Switch' OR B_Stance = 'Switch' THEN 1 ELSE 0 END) AS total_fights
    FROM fight_data
) AS stance_stats;


