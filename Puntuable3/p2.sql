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


/*2a*/
CREATE TRIGGER trig_2a BEFORE UPDATE ON empleat
BEGIN 
	SELECT RAISE(ABORT,'No hi ha suficients usuaris')  
		WHERE (SELECT COUNT(*) FROM empleat) < 3;-- (SEGONS ENUNCIAT.. ->) < 200 
END;


/*2b*/
CREATE TRIGGER trig_2b BEFORE UPDATE ON empleat
BEGIN 
	SELECT RAISE(ABORT,'El sou es massa baix!') 
		WHERE new.sou <= 100;
END;




UPDATE empleat
	SET sou = 2000; --NO FA UPDATE A 2000 PQE SON 2 EMPLEATS :)
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



/*2c*/

CREATE TABLE IF NOT EXISTS tuplesEsborrades(
	dataihora DATETIME,
	numTuples INTEGER
);

CREATE TRIGGER crea_nou BEFORE DELETE ON empleat 
FOR EACH ROW WHEN EXISTS 
	(SELECT dataihora from tuplesEsborrades WHERE dataihora=CURRENT_TIMESTAMP) 
BEGIN
	UPDATE tuplesEsborrades set numTuples=numTuples+1 where dataihora=CURRENT_TIMESTAMP;
END;


CREATE TRIGGER actualitza_nou BEFORE DELETE ON empleat 
FOR EACH ROW WHEN NOT EXISTS 
	(SELECT dataihora from tuplesEsborrades WHERE dataihora=CURRENT_TIMESTAMP) 
BEGIN
	INSERT INTO tuplesEsborrades VALUES (CURRENT_TIMESTAMP,0);
END;


DELETE FROM empleat where sou=5000;
SELECT * FROM empleat;
SELECT * FROM tuplesEsborrades;
DELETE FROM empleat;
SELECT * FROM tuplesEsborrades;

