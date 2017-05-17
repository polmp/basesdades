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
(1,"Carbonara",10,12),
(2,"Carbonara",12,15),
(3,"Carbonara",15,18),
(4,"Bbq",10,12),
(5,"Bbq",12,15),
(6,"Bbq",15,18),
(7,"Tropical",10,12),
(8,"Tropical",12,15),
(9,"Tropical",15,18)
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
(5,5,1);

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


