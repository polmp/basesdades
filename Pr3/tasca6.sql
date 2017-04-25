.mode column
.header on

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
INSERT OR IGNORE INTO empleats VALUES (13,'Negro','Empleat',4, '1975-04-15', 2000.00,182000,30);
INSERT OR IGNORE INTO empleats VALUES (14,'Rodriguez','Director',NULL, '1965-02-12', 4000,NULL,30);

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

INSERT OR IGNORE INTO client VALUES (1,'Pere','addr 1', 'Manresa', '08243', 666666666,963.57,'jeje',2);
INSERT OR IGNORE INTO client VALUES (2,'Andres','addr 2', 'Manresa', '08243', 666666669,863.57,'juju',2);
INSERT OR IGNORE INTO client VALUES (3,'Maria','addr 3', 'Barcelona', '08200', 666667666,1000.57,'jaja',5);

CREATE TABLE IF NOT EXISTS comanda (
 	c_num	INT PRIMARY KEY,
	c_data 	DATETIME,
 	c_tipus VARCHAR(1),--NULL
 	c_codi INT NOT NULL,
 	data_tramesa DATETIME,
 	p_codi INT,
 	quantitat INT,
 	--TOTAL               DECIMAL(8,2),
 	FOREIGN KEY (c_codi) REFERENCES client(c_codi),
 	FOREIGN KEY (p_codi) REFERENCES producte(p_codi),
 	CHECK (c_tipus IN ('A','B','C',NULL))
);

INSERT OR IGNORE INTO comanda VALUES (1,'2014-12-25',NULL,1,'2014-12-30',1,3);
INSERT OR IGNORE INTO comanda VALUES (2,'2014-04-10',NULL,2,'2014-05-12',1,2);
INSERT OR IGNORE INTO comanda VALUES (4, '2013-06-05', 'A', 1, '2013-06-05',2,1);
INSERT OR IGNORE INTO comanda VALUES (14, '2014-03-12', 'B', 2, '2014-03-12',1,1);
INSERT OR IGNORE INTO comanda VALUES (5, '2014-02-01', 'C', 3, '2014-02-01',2,3);
INSERT OR IGNORE INTO comanda VALUES (6, '2016-02-01', 'A', 1, '2016-02-05',1,1);
INSERT OR IGNORE INTO comanda VALUES (7, '2016-02-03', 'A', 3, '2016-02-10',2,4);
INSERT OR IGNORE INTO comanda VALUES (8, '2014-02-22', NULL, 2, '2014-02-04',1,2);
INSERT OR IGNORE INTO comanda VALUES (10, '2016-02-05', NULL, 1, '2016-03-03',1,3);
INSERT OR IGNORE INTO comanda VALUES (11, '2014-02-01', 'C', 3, '2014-02-06',2,1);
INSERT OR IGNORE INTO comanda VALUES (12, '2014-02-15', 'A', 2, '2014-03-06',1,1);
INSERT OR IGNORE INTO comanda VALUES (13, '2014-03-15', 'A', 2, '2014-01-01',2,3);


CREATE TABLE IF NOT EXISTS producte (
	p_codi  INT (6) PRIMARY KEY,
	preu INT,
	descrip	TEXT
);

INSERT OR IGNORE INTO producte VALUES (1,200,'Producte 1');
INSERT OR IGNORE INTO producte VALUES (2,150,'Producte 2');

--1. Mostrar els empleats (codi i cognom) juntament amb el codi i nom del departament al qual pertanyen.
SELECT e_codi,cognom,departament.d_num,d_nom from departament INNER JOIN empleats ON departament.d_num = empleats.d_num;

--2. Mostrar tots els departaments (codi i descripció) acompanyats del salari més alt dels seus empleats*/
SELECT d_nom,cognom,max(salari) from empleats INNER JOIN departament ON empleats.d_num = departament.d_num GROUP BY departament.d_num;

--3. Mostrar, en l'esquema empresa, tots els empleats acompanyats dels clients de qui són representants.
SELECT e_codi,cognom,client.c_codi,c_nom from client INNER JOIN empleats on empleats.e_codi = client.repr_codi;

--4. Mostrar tots els clients acompanyats de l’empleat que tenen com a representant.*/
SELECT c_codi,c_nom,e_codi,cognom from client INNER JOIN empleats ON client.repr_codi = empleats.e_codi;

--5. Mostrar els empleats (codi i cognom) juntament amb el codi i nom del departament al qual pertanyen.
SELECT e_codi,cognom,empleats.d_num,departament.d_nom from empleats INNER JOIN departament ON departament.d_num = empleats.d_num;

--6. Mostrar tots els departaments (codi i descripció) acompanyats del salari més alt dels seus empleats.
SELECT departament.d_num,departament.d_nom,max(salari) from empleats INNER JOIN departament ON empleats.d_num = departament.d_num GROUP BY departament.d_num;

--7. Mostrar els empleats de cada departament que tenen un salari major que el salari mitjà del mateix departament.
SELECT d_num,cognom,salari,avg(salari) from empleats GROUP BY d_num having salari > avg(salari);

--8. Mostrar els empleats que tenen el mateix ofici que l’ofici que té l'empleat de cognom SALA.
SELECT * from empleats where ofici in (SELECT ofici from empleats where cognom='Sala');

--9. Mostrar els noms i oficis dels empleats del departament 20 la feina dels quals coincideixi amb la d'algun empleat del departament de 'VENDES'.
-- FALTA COMPROVAR
SELECT cognom,ofici from empleats where ofici in (SELECT ofici from empleats INNER JOIN departament ON empleats.d_num = departament.d_num where departament.d_nom='VENDES') and d_num=20;

--10. Mostrar els empleats que efectuïn la mateixa feina que NEGRO o que tinguin un salari igual o superior al de GIL.
SELECT * from empleats where ofici IN (SELECT ofici from empleats where cognom='Negro') and cognom!='Negro' UNION SELECT * from empleats where salari > (SELECT salari from empleats where cognom='Gil' LIMIT 1);

--11. Mostrar els empleats (codi, cognom i nom del departament) de l'empresa que tenen el rang de director i ordenats pel cognom.
SELECT e_codi,cognom,departament.d_nom from empleats INNER JOIN departament ON empleats.d_num = departament.d_num where cap is null order by cognom;

--12. Mostrar l'import global que cada departament assumeix anualment en concepte de nòmina dels empleats i ordenat descendentment per l'import global.
SELECT departament.d_nom,sum(empleats.salari) as Total_Departament from departament INNER JOIN empleats on empleats.d_num = departament.d_num GROUP BY departament.d_num ORDER BY sum(empleats.salari) DESC;

--13. Mostrar els departaments ordenats ascendentment per l'antiguitat dels empleats.


--14. Mostrar els empleats (codi i cognom) acompanyats del nombre de comandes que han gestionat, ordenats pel cognom. Inclòs els empleats que no hagin pogut gestionar cap comanda.
SELECT e_codi,cognom,count(c_num) as Total_Comandes from (SELECT * from empleats LEFT JOIN client ON repr_codi = e_codi) as Taula LEFT JOIN comanda ON Taula.c_codi=comanda.c_codi GROUP BY e_codi ORDER BY cognom;

--15. Mostrar el rànquing dels empleats (codi i cognom), segons el nombre de comandes que han gestionat, que n'hagin gestionat més de tres. 
SELECT e_codi,cognom,count(c_num) as Total_Comandes from (SELECT * from empleats LEFT JOIN client ON repr_codi = e_codi) as Taula LEFT JOIN comanda ON Taula.c_codi=comanda.c_codi GROUP BY e_codi HAVING count(c_num)>3 ORDER BY count(c_num) DESC;

--16. Mostrar tots els productes amb el preu i la data de la darrera venda.
SELECT max_data.p_codi,producte.preu,darrera_data from (SELECT p_codi,max(data_tramesa) as darrera_data from comanda GROUP BY comanda.p_codi) as max_data INNER JOIN producte ON max_data.p_codi = producte.p_codi;

--17. Mostrar els clients que l'any 2016 van efectuar comandes per un import total que supera el 50 per cent del seu crèdit.
SELECT c_nom,sum(preu*quantitat),lim_cred*0.5 as Mitat_Credit from (SELECT * from client INNER JOIN comanda ON client.c_codi = comanda.c_codi where strftime('%Y',data_tramesa) = '2016') as total INNER JOIN producte ON producte.p_codi = total.p_codi group by c_codi having sum(preu*quantitat) > lim_cred*0.5;

