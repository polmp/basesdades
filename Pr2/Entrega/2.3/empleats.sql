.mode column
.header on

DROP TABLE IF EXISTS empleat;
DROP TABLE IF EXISTS feina;
DROP TABLE IF EXISTS empresa;
DROP TABLE IF EXISTS manager;

CREATE TABLE IF NOT EXISTS empleat (
	id_empleat INTEGER PRIMARY KEY,
	carrer varchar(30),
	ciutat varchar(30)
);

CREATE TABLE IF NOT EXISTS feina (
	id_empleat INTEGER,
	id_empresa INTEGER not null,
	salari INTEGER,
	FOREIGN KEY (id_empleat) REFERENCES empleat(id_empleat)
);

CREATE TABLE IF NOT EXISTS empresa (
	id_empresa INTEGER PRIMARY KEY,
	ciutat varchar(30)
);

CREATE TABLE IF NOT EXISTS manager (
	id_empleat INTEGER,
	id_empleat_coordinador INTEGER,
	FOREIGN KEY(id_empleat) REFERENCES empleat(id_empleat)
);

INSERT INTO empleat (id_empleat,carrer,ciutat) VALUES (1,'Carrer Hola','Madrid');
INSERT INTO empleat (id_empleat,carrer,ciutat) VALUES (2,'Carrer Pio','Madrid');
INSERT INTO empleat (id_empleat,carrer,ciutat) VALUES (3,'Carrer Adeu','Murcia');
INSERT INTO empleat (id_empleat,carrer,ciutat) VALUES (4,'Carrer Huehue','Sevilla');
INSERT INTO empleat (id_empleat,carrer,ciutat) VALUES (5,'Carrer Pole','Granada');

INSERT INTO feina VALUES (1,10,15000);
INSERT INTO feina VALUES (2,10,9500);
INSERT INTO feina VALUES (3,12,3000);
INSERT INTO feina VALUES (4,11,1200);
INSERT INTO feina VALUES (5,11,1200);

--Empresa 10: Bank newton

INSERT INTO empresa VALUES (10,'Barcelona');
INSERT INTO empresa VALUES (11,'Galicia');
INSERT INTO empresa VALUES (12,'Murcia');

INSERT INTO manager VALUES (1,2);
INSERT INTO manager VALUES (4,5);