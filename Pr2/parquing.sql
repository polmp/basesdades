.mode column
.header on

DROP TABLE IF EXISTS parquing;

CREATE TABLE IF NOT EXISTS parquing (
	matricula char(7) PRIMARY KEY unique not null check(5<length(matricula)<8),
	plasa INT not null unique not null,
	color char(10),
	model char(10),
	data DATETIME default CURRENT_TIMESTAMP
) ;


INSERT INTO parquing(matricula, plasa, data, color, model) VALUES ('1234ABC',4,'2016-12-12 10:13:02','Vermell','Seat');
INSERT INTO parquing(matricula, plasa, data, color, model) VALUES ('1234ABD',5,'2017-05-02 09:45:12','Groc','Toyota');
INSERT INTO parquing(matricula, plasa, data, color, model) VALUES ('1234ABE',6,CURRENT_TIMESTAMP,'Verd','Seat');
INSERT INTO parquing(matricula, plasa, data, color, model) VALUES ('1234ABED',6,CURRENT_TIMESTAMP,'Verd','Seat');


SELECT * FROM parquing;
/*
SELECT * FROM PARQUING where matricula='1234ABC';

SELECT * FROM PARQUING WHERE DATEDIFF(day,data,NOW()) as diffTIME where diffTIME > 1; */
/*SELECT CURRENT_TIMESTAMP-data as dif from parquing;*/
/*SELECT julianday('now')-julianday(data) as diffTIME from parquing <= 30;*/

/*SELECT * FROM parquing WHERE (julianday(data) - julianday(CURRENT_TIMESTAMP)) AS diff;/


SELECT (julianday(data) - julianday(CURRENT_TIMESTAMP)) AS diff FROM parquing;*/


/*SELECT julianday(CURRENT_TIMESTAMP), julianday(data) AS diff FROM parquing;*/



/* COTXES ENTRATS QUE TENEN MES DE UN DIA */
 SELECT * FROM parquing where (julianday(CURRENT_TIMESTAMP) - julianday(data))>1 ORDER BY plasa;

/*PLACES OCUPADES*/
SELECT plasa FROM parquing;

/*PLACES BUIDES*/






--DROP TABLE IF EXISTS Testing;

