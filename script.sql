 SELECT 
    CONCAT(
    SUBSTRING(TIME,1,10)," ",
    sec_to_time(time_to_sec(TIME)- time_to_sec(TIME)%(5*60))
    ) AS TIMEINTER,
    ROUND(AVG(WERT),2) AS WERT
 
FROM `1press30`
    WHERE 
SUBSTRING(TIME,1,10) = '2015-07-17'
    GROUP BY TIMEINTER
INTO OUTFILE '/tmp/2015-07-17-press.csv'
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n';

