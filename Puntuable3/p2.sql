.mode column
.header on

CREATE TABLE empleat
(
	nemp char(10) PRIMARY KEY,
	nom char(25),
	sou integer not null
);


INSERT INTO empleat VALUES (1,'Guillem',1000),(2,'Pau',1500);

SELECT * FROM empleat;

CREATE TRIGGER trig_2a BEFORE UPDATE ON empleat
BEGIN 
	SELECT RAISE(IGNORE) WHERE (SELECT COUNT(*) FROM empleat) < 3;-- <200
END;


CREATE TRIGGER trig_2b BEFORE UPDATE ON empleat
BEGIN 
	SELECT RAISE(IGNORE) WHERE new.sou <= 100;
END;
	


UPDATE empleat
	SET sou = 2000; --NO FA UPDATE A 200 PQE SON 2 EMPLEATS :)
SELECT * FROM empleat;


INSERT INTO empleat VALUES (3,'Sandra',1600);
INSERT INTO empleat VALUES (4,'Sandra',1600);

SELECT * FROM empleat;

UPDATE empleat
	SET sou = 5000;

SELECT * FROM empleat;

DELETE FROM empleat WHERE nemp = 2;

SELECT * FROM empleat;

UPDATE empleat
	SET sou = 80; --IGNORA EL UPDATE JA QUE NO SUPERA ELS 100 :)

SELECT * FROM empleat;



UPDATE empleat
	SET sou = 101; --FA EL UPDATE JA QUE SUPERA ELS 100 :)

SELECT * FROM empleat;



CREATE TABLE tuplesEsborrades
(
dataHora timestamp PRIMARY KEY,
numTuples int
);



CREATE TRIGGER trig_2c BEFORE DELETE ON empleat
BEGIN
	INSERT  OR IGNORE INTO tuplesEsborrades VALUES ((select strftime("%Y-%m-%d %H:%M:%f", "now")), (SELECT changes() FROM empleat));
END;

SELECT * FROM tuplesEsborrades;

DELETE FROM empleat;

SELECT * FROM tuplesEsborrades;


INSERT INTO empleat VALUES (1,'Guillem',1000),(2,'Pau',1500);

SELECT * FROM empleat;

/*

dataHora                 numTuples 
-----------------------  ----------
2017-05-23 15:20:39.272  3         
nemp        nom         sou       
----------  ----------  ----------
1           Guillem     1000      
2           Pau         1500      
sqlite> DELETE FROM empleat;
sqlite> 
sqlite> SELECT * FROM tuplesEsborrades;
dataHora                 numTuples 
-----------------------  ----------
2017-05-23 15:20:39.272  3         
2017-05-23 15:20:41.476  2         

*/