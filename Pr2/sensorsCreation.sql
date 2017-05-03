.mode column
.header on

DROP TABLE IF EXISTS sensors;
DROP TABLE IF EXISTS calib_temp; 
DROP TABLE IF EXISTS calib_light;
/*
sqlite3 sensors.bd < sensorsCreation.sql >out.txt
*/
CREATE TABLE IF NOT EXISTS sensors (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 result_time  DATETIME,
 epoch INT,
 nodeid INT,
 light INT,
 temp INT,
 voltage INT) ;


INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 09:10:18',639,1,555,26,400);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 10:20:10',653,1,556,12,420);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 10:30:11',683,1,557,38,430);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 11:33:15',712,1,558,15,433);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 11:40:23',715,1,560,0,512);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 12:42:28',725,1,562,27,323);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES (DATETIME('now'),727,1,555,20,401);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES (DATETIME('now'),729,1,566,12,333);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES (DATETIME('now'),732,1,568,13,0);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 09:10:18',639,2,555,0,325);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 10:20:10',653,2,556,5,386);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 10:30:11',683,2,557,10,402);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 11:33:15',712,2,558,11,415);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 11:40:23',715,2,560,12,411);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 12:42:28',725,2,562,13,450);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES (DATETIME('now'),727,2,564,14,300);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES (DATETIME('now'),729,2,566,15,400);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES (DATETIME('now'),734,2,568,16,408);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 09:10:18',639,3,555,-2,418);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 10:20:10',653,3,556,0,300);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 10:30:11',683,3,557,2,0);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 11:33:15',712,3,558,4,420);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 11:40:23',715,3,560,10,478);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 12:42:28',725,3,562,12,499);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES (DATETIME('now'),727,3,564,13,501);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES (DATETIME('now'),729,3,566,14,512);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES (DATETIME('now'),729,3,568,15,534);

INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 20:20:10',653,3,556,0,300);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 20:59:11',683,3,557,2,0);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 21:00:00',712,3,558,4,120);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 21:40:23',715,3,560,10,278);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 18:42:28',725,3,562,12,479);

INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 20:20:10',653,1,556,0,300);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 20:59:11',683,1,557,2,0);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 21:00:00',712,1,558,4,220);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 21:40:23',715,1,560,10,278);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 18:42:28',725,1,562,12,399);

INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 20:20:10',653,2,556,0,300);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 20:59:11',683,2,557,2,0);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 21:00:00',712,2,558,4,220);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 21:40:23',715,2,560,10,278);
INSERT INTO sensors (result_time,epoch,nodeid,light,temp,voltage) VALUES ('2015-03-05 18:42:28',725,2,962,12,199);



CREATE TABLE calib_temp as select temp, avg(temp)+temp as calib from sensors group by temp;
CREATE TABLE calib_light as select light, avg(light)+light as calib from sensors group by light;

/*
SELECT * FROM calib_light;
SELECT * FROM calib_temp;
*/

-- 1. Write a query (using the SELECT statement) that will compute times
-- and ids when any sensor’s light reading was above 550. Show both the query
-- and the first few lines of the result.

--SELECT nodeid,result_time FROM sensors WHERE light > 550;
--SELECT nodeid,result_time FROM sensors WHERE light > 550 limit 2;

--2. Write a query that will compute the average light reading at sensor 1 between 6 PM and 9
-- PM (inclusive of 6:00:00 PM and 9:00:00 PM). Show the query and the result.


/*SELECT *,cast( (strftime('%H',result_time)) as int) as HORES, 
						cast( (strftime('%M',result_time)) as int) as MINUTS,
						cast( (strftime('%S',result_time)) as int) as SEGONS 
	from sensors WHERE ((HORES BETWEEN 18 AND 21) OR (HORES = 21 AND MINUTS = 0 AND SEGONS = 0));
*/

--SELECT nodeid,MitjanaLlum from (SELECT nodeid,avg(light) as MitjanaLlum,time(result_time) as temps from sensors where temps between '18:00:00' and '21:00:00' group by nodeid having nodeid=1);


--NOMES LES HORES DE 18 A 21
/*SELECT * from sensors WHERE (( (cast( (strftime('%H',result_time)) as int)) BETWEEN 18 AND 20)
							OR ((cast( (strftime('%H',result_time)) as int)) = 21 AND (cast( (strftime('%M',result_time)) as int)) = 0) AND (cast( (strftime('%S',result_time)) as int)) = 00);
*/

--AVERAGE LIGHT AND TEMP, GROUP BY NODE
/*
SELECT avg(light), avg(temp), nodeid from sensors WHERE ((( (cast( (strftime('%H',result_time)) as int)) BETWEEN 18 AND 20)
							OR ((cast( (strftime('%H',result_time)) as int)) = 21 AND (cast( (strftime('%M',result_time)) as int)) = 0) AND (cast( (strftime('%S',result_time)) as int)) = 00)
							) GROUP BY nodeid;
*/
-- 3. Write a single query that computes the average temperature and light reading at every
-- sensor between 6 PM and 9 PM, but exclude any sensors whose maximum voltage was
-- greater than 418 during that time period. Show both the query and the result.

/*SELECT *, light,temp, nodeid, voltage, max(voltage) from sensors WHERE ((( (cast( (strftime('%H',result_time)) as int)) BETWEEN 18 AND 20)
							OR ((cast( (strftime('%H',result_time)) as int)) = 21 AND (cast( (strftime('%M',result_time)) as int)) = 0) AND (cast( (strftime('%S',result_time)) as int)) = 00)
							) GROUP BY nodeid 
							;--EXCEPT SELECT avg(light), avg(temp), nodeid, max(voltage) FROM sensors WHERE voltage > 418 GROUP BY nodeid;
							*/


--SELECT avg(light), avg(temp), nodeid, max(voltage) FROM sensors WHERE voltage > 418 GROUP BY nodeid;

--SELECT * FROM sensors GROUP BY nodeid EXCEPT SELECT * FROM sensors WHERE LIGHT > 800;

-- Versio 2

--SELECT nodeid,MitjanaLlum,MitjanaTemp from (SELECT nodeid,avg(light) as MitjanaLlum,time(result_time) as temps,avg(temp) as MitjanaTemp, max(voltage) as maxvoltatge from sensors where temps between '18:00:00' and '21:00:00' group by nodeid having maxvoltatge < 418);


-- 4. Write a query that computes the average calibrated temperature readings from sensor 2 during each hour, inclusive, between 6 PM and 9 PM (i.e., your
-- answer should consist of 4 rows of calibrated temperatures.)
--SELECT *, light,temp, nodeid, voltage from sensors WHERE ((( (cast( (strftime('%H',result_time)) as int)) BETWEEN 18 AND 20) OR ((cast( (strftime('%H',result_time)) as int)) = 21 AND (cast( (strftime('%M',result_time)) as int)) = 0) AND (cast( (strftime('%S',result_time)) as int)) = 00));

/*
SELECT strftime("%H",result_time),temp,avg(temp)+temp,/*calib_temp.calib*//*nodeid from sensors*/--,calib_temp 
/*			where ( nodeid = 2 and 
				--time(result_time) between "18" and "21" 

				(( (cast( (strftime('%H',result_time)) as int)) BETWEEN 18 AND 20)
							OR ((cast( (strftime('%H',result_time)) as int)) = 21 AND (cast( (strftime('%M',result_time)) as int)) = 0) AND (cast( (strftime('%S',result_time)) as int)) = 00)

				) group by strftime("%H",result_time);
/*
--5. Write a query that computes all the epochs during which the results from sensors 1 and 2 arrived more than 1 second apart. 
--Show the query and the result.

/*
SELECT s1.nodeid,s2.nodeid,s1.result_time,s2.result_time,s1.epoch from sensors as s1, sensors as s2 
	where s1.nodeid != s2.nodeid 
		and s1.epoch == s2.epoch 
		and (time(s1.result_time) > time(s2.result_time,'+1 second') 
		or time(s2.result_time) > time(s1.result_time,'+1 second')) 
		and (s1.nodeid==1 or s2.nodeid==1) 
		and (s1.nodeid==2 or s2.nodeid=2);


--6. Write a query that determines epochs during which one or two of the sensors did not return results. Show your query and the first few results, sorted in by epoch number. 
--You may wish to use a nested query – that is, a SELECT statement within the FROM clause of another SELECT statement.

SELECT epoch,nodeid,light,temp from sensors group by epoch having count(epoch) < 3;
*/



--7. Write a query that produces a temperature reading for each of the three sensors during
--   any epoch in which any sensor produced a reading. If a sensor is missing a value during a
--   given epoch, your result should report the value of this sensor as the most recent previously
--   reported value. If there is no such value (e.g., the first value for a particular sensor is
--   missing), you should return the special value ’null’. You may wish to read about the CASE
--   and OUTER JOIN SQL statements.

SELECT s1.nodeid, s1.epoch,
	(CASE s1.temp 
		when s1.temp=null then
			(SELECT temp from sensors where epoch = (SELECT max(epoch) from sensors where epoch<s1.epoch and nodeid=s1.nodeid) and nodeid = s2.nodeid)
 		else 
 			s1.temp
 	end
 	)
from sensors as s1
left join sensors s2 using(nodeid)
union all
select s1.nodeid,s1.epoch,
SELECT s1.nodeid,s1.epoch,
	(CASE s1.temp when s1.temp=null then
			(SELECT temp from sensors where epoch = (SELECT max(epoch) from sensors where epoch<s1.epoch and nodeid=s1.nodeid) and nodeid = s2.nodeid)
 		else 
 			s1.temp
 	end
 	)
from sensors s2
left join sensors s1 using(nodeid)
SELECT nodeid,epoch from 
	(SELECT distinct epoch from sensors) as s1,
	(SELECT distinct epoch from sensors) as s2 
	on (s1.nodeid = s2.nodeid and s1.epoch = s2.epoch)
order by s1.epoch,s1.nodeid;

--8. Write a query that determines epochs during which all three sensors did not return any
--   results. Note that this is a deceptively hard query to write – you may need to make some
--   assumptions about the frequency of missing epochs.
/*
SELECT distinct(epoch) as "Epoch lost", (epoch-(SELECT max(epoch) from sensors as s1 where s1.epoch<s2.epoch)) as "epoch lost early"
from (SELECT epoch-1 as epoch from sensors except SELECT epoch from sensors) as s2
where epoch < (SELECT min(epoch) from sensors);
*/
