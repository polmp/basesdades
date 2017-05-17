.mode column
.header on

drop table if exists productes;

create table productes (
	idProducte char(9),
	nom char(20), 
	preu integer check (preu > 0),
	mida char(20),
	primary key(idProducte),
	unique(nom, mida)
);

INSERT INTO productes VALUES 
(1,"Carbonara",12,'12cm'),
(2,"Carbonara",15,'15cm'),
(3,"Carbonara",18,'18cm'),
(4,"Bbq",10,'12cm'),
(5,"Bbq",12,'15cm'),
(6,"Bbq",15,'18cm'),
(7,"Tropical",10,'12cm'),
(8,"Tropical",12,'15cm'),
(9,"Tropical",15,'18cm'),
(10,"Napolitana",13,'12cm'),
(11,"Napolitana",15,'15cm'),
(12,"Napolitana",20,'18cm'),
(101, "Joguina 1", 3, ''),
(102, "Joguina 2", 3, ''),
(103, "Joguina 3", 8, '')
;

create table domicilis(
	numTelf char(9),
	carrer char(20),
	numCarrer integer check (numCarrer > 0),
	pis char(2),
	porta char(2),
	primary key(numTelf));

INSERT INTO domicilis VALUES
(666777888,"c/ ASDF", 4, 1, 4),
(777888999,"c/ QWERTY", 15, 9, 1),
(666777889,"c/ ZXCVB", 40, '', ''),
(666778888,"c/ POIUYT", 1, 3, 2),
(666779888,"c/ ÑLKJH", 10, 6, '')
;

create table comandes(
	numComanda integer check(numComanda>0),
	instantFeta integer not null check(instantFeta>0),
	instantServida integer check(instantServida>0),
	numTelf char(9),
	import integer check(import>0),
	primary key(numComanda),
	foreign key(numTelf) references domicilis,
	check(instantServida>instantFeta));


INSERT INTO comandes VALUES 
(1,20170517220000,20170517223000,666777888,15),
(2,20170517220200,20170517223400,777888999,20),
(3,20170517200000,20170517203000,666779888,8),
(4,20170517200000,20170517203000,666779888,10),
(5,20170517210000,20170517213000,666777889,14)
;

create table liniesComandes(
	numComanda integer,
	idProducte char(9),
	quantitat integer check(quantitat>0),
	primary key(numComanda, idProducte),
	foreign key(numComanda) references comandes,
	foreign key(idProducte) references productes
);

INSERT INTO liniesComandes VALUES
(1,1,1),
(1,5,2),
(2,2,3),
(2,4,1),
(3,1,1),
(3,2,1),
(4,4,1),
(5,5,1),
(1,12,1),
(3,12,2),
(2,12,3)
;

/*
SELECT * FROM productes;
SELECT * FROM domicilis;
SELECT * FROM comandes;
SELECT * FROM liniesComandes; 
*/
--EX1: OBTENIR QUANTITAT DE CARRERS ON SHAN SERVIT COMANDES NO DE NO MES DE 10 EUROS

SELECT COUNT(*) FROM (
SELECT comandes.numTelf,comandes.import FROM comandes
INNER JOIN
	(SELECT * FROM domicilis) AS d
ON D.numTelf = comandes.numTelf
WHERE comandes.import <= 10
);

--EX2 (WTF..)

--EX3

CREATE TABLE regals(
idProdComprat char(9),
idProdRegalat char(9),
primary key (idProdComprat,idProdRegalat),
foreign key (idProdComprat) references productes(idProducte),
foreign key (idProdRegalat) references productes(idProducte)
);

 
--CREAR TRIGGER WHEN INSERT
 INSERT INTO regals VALUES
 (12,103),(12,101),(1,102),(2,101),(3,101),(5,103),(7,101),(10,103),(9,103),(11,102);


--SELECT idProdComprat,P1.nom as nomProdComprat, P1.preu as preuProdComp (
/* SELECT * FROM regals
INNER JOIN 
(SELECT * FROM productes) AS P1
ON P1.idProducte = regals.idProdComprat

--)
;
*/


SELECT SUM(QxP) FROM (

SELECT numComanda,idProdComprat,midaComprat,quantitat,idNomComp,idProdRegalat,NomRegal,preuRegal,
	quantitat*preuRegal AS QxP FROM liniesComandes

INNER JOIN (

SELECT idProdComprat,midaComprat,idNomComp,preuComprat,idProdRegalat,
		REG.nom as NomRegal, REG.preu as preuRegal FROM (
-- ***************
SELECT idProdComprat,r.mida as midaComprat,r.nom as idNomComp,r.preu as preuComprat,idProdRegalat 
	FROM productes
INNER JOIN 

(
SELECT * FROM regals
INNER JOIN 
(SELECT * FROM productes) AS P1
ON P1.idProducte = regals.idProdComprat) AS r

ON  productes.idProducte = r.idProducte) as t1
-- ***************
INNER JOIN
(SELECT * FROM productes) AS REG
ON  t1.idProdRegalat = REG.idProducte

) AS t2

ON liniesComandes.idProducte = t2.idProdComprat

WHERE idProducte = 12
)
;




--SELECT * FROM liniesComandes;



