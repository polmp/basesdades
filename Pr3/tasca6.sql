CREATE TABLE IF NOT EXISTS departament (
 	d_num	INT PRIMARY KEY,
 	d_nom	VARCHAR(14) NOT NULL UNIQUE,
 	d_loc	VARCHAR(14)
 );

INSERT OR IGNORE INTO departament VALUES (10, 'COMPTABILITAT', 'SEVILLA');
INSERT OR IGNORE INTO departament VALUES (20, 'INVESTIGACIO', 'MADRID');
INSERT OR IGNORE INTO departament VALUES (30, 'VENDES', 'BARCELONA');
INSERT OR IGNORE INTO departament VALUES (40, 'PRODUCCIÓ', 'BILBAO');


CREATE TABLE IF NOT EXISTS empleats (
 	e_codi    INT PRIMARY KEY,
 	cognom    VARCHAR (10) NOT NULL,
 	ofici     VARCHAR (10), /*Director, analista, president, empleat, venedor, secretari,.*/
 	cap 	INT, /*CAP QUE TE EMPLEAT*/
 	data_alta DATETIME,
 	salari    DECIMAL(12,2),
 	comissio  DECIMAL(4,2), 	
 	d_num	INT,
	FOREIGN KEY (d_num) REFERENCES departament(d_num),
	FOREIGN KEY (cap) REFERENCES emp(e_codi)
);


INSERT OR IGNORE INTO empleats VALUES (1,'Sanchez','Empleat',4, '1980-12-17', 1040.00,NULL,20);
INSERT OR IGNORE INTO empleats VALUES (2,'Arroyo','Venedor',4, '1980-02-20', 2080.00,39000,30);
INSERT OR IGNORE INTO empleats VALUES (3,'Sala','Venedor',4, '1981-02-22', 1625.00,65000,30);
INSERT OR IGNORE INTO empleats VALUES (4,'Jimenez','Director',NULL, '1981-04-02', 3867.50,NULL,20);
INSERT OR IGNORE INTO empleats VALUES (5,'Martinez','Venedor',4, '1981-09-29', 1625.00,182000,30);
INSERT OR IGNORE INTO empleats VALUES (11,'Alonso','Pilot',4, '1981-09-23', 1430.00,NULL,40);
INSERT OR IGNORE INTO empleats VALUES (12,'Gil','Venedor',4, '1967-02-13', 1650,39000,30);


CREATE TABLE IF NOT EXISTS client (
 	c_codi	INT(6) PRIMARY KEY,
 	c_nom	VARCHAR (45) NOT NULL,
 	addr	VARCHAR (40) NOT NULL,
 	ciutat	VARCHAR (30) NOT NULL,
 	codi_post VARCHAR (9) NOT NULL,
 	telf	NUMERIC(9,0),
 	lim_cred	DECIMAL(9,2),
 	obs		TEXT,
 	repr_codi INT,
 	FOREIGN KEY (repr_codi) REFERENCES empleats(e_codi)
);

INSERT OR IGNORE INTO client VALUES (1,'Pere','addr 1', 'Manresa', '08243', 666666666,963.57,'pringat',2);
INSERT OR IGNORE INTO client VALUES (2,'Andres','addr 2', 'Manresa', '08243', 666666669,863.57,'molt pringat',2);
INSERT OR IGNORE INTO client VALUES (3,'Maria','addr 3', 'Barcelona', '08200', 666667666,63.57,'pringada',5);

CREATE TABLE IF NOT EXISTS comanda (
 	c_num	INT PRIMARY KEY,
	c_data 	DATETIME,
 	c_tipus VARCHAR(1),--NULL
 	c_codi INT NOT NULL,
 	data_tramesa DATETIME,
 	--TOTAL               DECIMAL(8,2),
 	FOREIGN KEY (c_codi) REFERENCES client(c_codi),
 	CHECK (c_tipus IN ('A','B','C',NULL))
);

INSERT OR IGNORE INTO comanda VALUES (1,'2014-12-25',NULL,100,'2014-12-30');
INSERT OR IGNORE INTO comanda VALUES (2,'2014-04-10',NULL,101,'2014-05-12');
INSERT OR IGNORE INTO comanda VALUES (4, '2013-06-05', 'A', 102, '2013-06-05');
INSERT OR IGNORE INTO comanda VALUES (14, '2014-03-12', 'B', 100, '2014-03-12');
INSERT OR IGNORE INTO comanda VALUES (5, '2014-02-01', 'C', 108, '2014-02-01');
INSERT OR IGNORE INTO comanda VALUES (6, '2014-02-01', 'A', 120, '2014-02-05');
INSERT OR IGNORE INTO comanda VALUES (7, '2014-02-03', 'A', 103, '2014-02-10');
INSERT OR IGNORE INTO comanda VALUES (8, '2014-02-22', NULL, 104, '2014-02-04');
INSERT OR IGNORE INTO comanda VALUES (10, '2014-02-05', NULL, 104, '2014-03-03');
INSERT OR IGNORE INTO comanda VALUES (11, '2014-02-01', 'C', 107, '2014-02-06');
INSERT OR IGNORE INTO comanda VALUES (12, '2014-02-15', 'A', 102, '2014-03-06');
INSERT OR IGNORE INTO comanda VALUES (13, '2014-03-15', 'A', 100, '2014-01-01');


CREATE TABLE IF NOT EXISTS producte (
	p_codi  INT (6) PRIMARY KEY,
	descrip	TEXT
);


--1. Mostrar els empleats (codi i cognom) juntament amb el codi i nom del departament al qual pertanyen.*/
--SELECT e_codi,cognom,d_num,d_nom from departament INNER JOIN empleats ON departament.d_num = empleats.d_num;

--2. Mostrar tots els departaments (codi i descripció) acompanyats del salari més alt dels seus empleats*/
--SELECT d_nom,cognom,max(salari) from empleats INNER JOIN departament ON empleats.d_num = departament.d_num GROUP BY departament.d_num;

--3. Mostrar, en l’esquema empresa, tots els empleats acompanyats dels clients de qui són representants.*/


--4. Mostrar tots els clients acompanyats de l’empleat que tenen com a representant.*/
--SELECT c_codi,c_nom,e_codi,cognom from client INNER JOIN empleats ON client.repr_codi = empleats.e_codi;

--5. Mostrar els empleats (codi i cognom) juntament amb el codi i nom del departament al qual pertanyen.

--6. Mostrar tots els departaments (codi i descripció) acompanyats del salari m ́es alt dels seus empleats.
--SELECT departament.d_num,departament.d_nom,max(salari) from empleats INNER JOIN departament ON empleats.d_num = departament.d_num GROUP BY departament.d_num;

--7. Mostrar els empleats de cada departament que tenen un salari major que el salari mitjà del mateix departament.

--8. Mostrar els empleats que tenen el mateix ofici que l’ofici que té l'empleat de cognom SALA.
--SELECT * from empleats where ofici in (SELECT ofici from empleats where cognom='Sala');

--9. Mostrar els noms i oficis dels empleats del departament 20 la feina dels quals coincideixi amb la d'algun empleat del departament de 'VENDES'.
-- FALTA COMPROVAR
--SELECT cognom,ofici from empleats where ofici in (SELECT ofici from empleats INNER JOIN departament ON empleats.d_num = departament.d_num where departament.d_nom='VENDES') and d_num=20;

--10. Mostrar els empleats que efectuïn la mateixa feina que NEGRO o que tinguin un salari igual o superior al de GIL.
--SELECT * from empleats where ofici IN (SELECT ofici from empleats where cognom='NEGRO') UNION SELECT * from empleats where salari > (SELECT salari from empleats where cognom='Gil' LIMIT 1);

