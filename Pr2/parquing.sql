CREATE TABLE IF NOT EXISTS parquing (
	matricula char(7) PRIMARY KEY,
	plasa INT not null unique,
	data DATETIME,
	color char(10),
	model char(10)
) ;

/*
INSERT INTO parquing(matricula, plasa, data, color, model) VALUES ('1234ABC',4,'2017-03-01 10:13:02','Vermell','Seat');
INSERT INTO parquing(matricula, plasa, data, color, model) VALUES ('1234ABD',5,'2017-03-02 09:45:12','Groc','Toyota');
INSERT INTO parquing(matricula, plasa, data, color, model) VALUES ('1234ABE',6,CURRENT_TIMESTAMP,'Verd','Seat');
*/
/*SELECT * FROM parquing;

SELECT * FROM PARQUING where matricula='1234ABC';

SELECT * FROM PARQUING WHERE DATEDIFF(day,data,NOW()) as diffTIME where diffTIME > 1; */
/*SELECT CURRENT_TIMESTAMP-data as dif from parquing;*/
/*SELECT julianday('now')-julianday(data) as diffTIME from parquing <= 30;*/

SELECT * FROM parquing WHERE (julianday(data) - julianday(CURRENT_TIMESTAMP)) as diff;

