.mode column
.header on
CREATE TABLE IF NOT EXISTS Clients (
	nif varchar(9) PRIMARY KEY,
	raosocial char(10),
	adreça varchar(50),
	telefon INT,
	descompte REAL
);

CREATE TABLE IF NOT EXISTS Centres (
	codi INT PRIMARY KEY,
	ciutat varchar(15),
	zona varchar(15)
);

CREATE TABLE IF NOT EXISTS Productes (
	codi INT PRIMARY KEY,
	descripcio varchar(50),
	preu REAL,
	estoc INT
);

CREATE TABLE IF NOT EXISTS Venedors (
	codi INT PRIMARY KEY,
	nom varchar(15),
	edat INT,
	codiCentre INT,
	FOREIGN KEY (codiCentre) REFERENCES Centres(codi)
);

CREATE TABLE IF NOT EXISTS Comandes (
	numerocomanda INT PRIMARY KEY,
	codiProducte INT,
	codiVenedor INT,
	nif varchar(9),
	data DATETIME,
	unitats INT,
	FOREIGN KEY (codiProducte) REFERENCES Productes(codi),
	FOREIGN KEY (codiVenedor) REFERENCES Venedors(codi)
);

/* Codi centre -> 1 - 9 
	Codi producte -> 100-999
	Codi venedor -> 1000-9999
	Codi comanda -> 10000 - 99999
*/

INSERT OR IGNORE INTO Clients VALUES ('1234ABC','RaoSocial1','Adreça 1',656736455,10);
INSERT OR IGNORE INTO Clients VALUES ('3456FGF','RaoSocial2','Adreça 2',645854543,5);
INSERT OR IGNORE INTO Clients VALUES ('6746TYF','RaoSocial3','Adreça 3',683768356,5);
INSERT OR IGNORE INTO Clients VALUES ('6948GBC','RaoSocial4','Adreça 4',694968464,7);

INSERT OR IGNORE INTO Centres VALUES (1,'Manresa','Viladordis');
INSERT OR IGNORE INTO Centres VALUES (2,'Manresa','Cal Gravat');
INSERT OR IGNORE INTO Centres VALUES (3,'Manresa','La Font');
INSERT OR IGNORE INTO Centres VALUES (4,'Manresa','La Balconada');

INSERT OR IGNORE INTO Comandes VALUES (1,10000,1000,'1234ABC',date('now'),3);
INSERT OR IGNORE INTO Comandes VALUES (2,10000,1000,'3456FGF',date('now'),5);
INSERT OR IGNORE INTO Comandes VALUES (3,10001,1001,'3456FGF',date('now'),5);

INSERT OR IGNORE INTO Venedors VALUES (1000,'Antoni',26,1);
INSERT OR IGNORE INTO Venedors VALUES (1001,'Pere',22,2);
INSERT OR IGNORE INTO Venedors VALUES (1002,'Miguel',23,2);

INSERT OR IGNORE INTO Productes VALUES (10000,'Producte1',100,5);
INSERT OR IGNORE INTO Productes VALUES (10001,'Producte2',50,10);
INSERT OR IGNORE INTO Productes VALUES (10002,'Producte3',50,10);

/* 1. Eliminar els productes sense stock */
--DELETE FROM Productes where estoc = 0;

/* 2. Modificar els tres primers clients de la base de dades, que rebran una bonificació de l’1.5 per cent en les seves compres*/
--UPDATE clients SET descompte = 1.5 where nif in (select nif from clients LIMIT 3);

/* 3. Obtenir el llistat de monitors que hi ha en estoc */
SELECT * from Productes where descripcio='Monitor' and estoc > 0;

/*4. Obtenir el llistat dels punts de venta assignats als venedors amb edat compresa entre 21 i 26 anys, ordenant la sortida per l’edat dels venedors*/
SELECT Centres.codi, Centres.ciutat, Centres.zona, Venedors.nom,Venedors.edat from Centres INNER JOIN Venedors ON Venedors.codiCentre = Centres.codi where Venedors.edat BETWEEN 21 and 26 ORDER BY Venedors.edat;

/*5. Obtenir l’import total de les compres fetes per cada client l’any 2016, considerant el descompte.*/
SELECT nif,sum(preu*unitats*(1-(descompte/100))) as ImportTotal from (SELECT * from Clients INNER JOIN Comandes ON Clients.nif = Comandes.nif WHERE strftime('%Y',data) == '2017') as Client_Producte INNER JOIN Productes ON Client_Producte.codiProducte = Productes.codi GROUP BY Client_Producte.nif;

/*6. Obtenir la llista dels deu primers venedors de la BD amb el total d’unitats venudes, fins i tot per a aquells venedors que no van tenir cap comanda.*/
SELECT Venedors.codi,Venedors.nom,sum(unitats) as TotalUnitats from Venedors LEFT JOIN Comandes ON Venedors.codi == Comandes.codiVenedor GROUP BY Venedors.codi;

/*7. Obtenir el llistat de productes inactius (no apareixen en comandes)*/
SELECT codi,descripcio from Productes LEFT JOIN Comandes ON Productes.codi = Comandes.codiProducte WHERE Comandes.codiProducte is null GROUP BY Productes.codi;

