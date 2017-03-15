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
	id_empleat INTEGER,
	ciutat varchar(30),
	FOREIGN KEY(id_empleat) REFERENCES empleat(id_empleat)
);

CREATE TABLE IF NOT EXISTS manager (
	id_empleat INTEGER,
	id_empleat_coordinador INTEGER,
	FOREIGN KEY(id_empleat) REFERENCES empleat(id_empleat)
);

INSERT INTO empleat VALUES (1,'Carrer Hola','Barcelona');
INSERT INTO empleat (id_empleat,carrer,ciutat) VALUES (2,'Carrer Pio','Madrid');
INSERT INTO empleat (id_empleat,carrer,ciutat) VALUES (3,'Carrer Adeu','Badajoz');
INSERT INTO empleat (id_empleat,carrer,ciutat) VALUES (4,'Carrer Huehue','Sevilla');

INSERT INTO feina VALUES (1,10,15000);
INSERT INTO feina VALUES (2,10,9500);
INSERT INTO feina VALUES (3,10,3000);
INSERT INTO feina VALUES (4,11,1200);

--Empresa 10: Bank newton

INSERT INTO empresa VALUES (10,'Barcelona');
INSERT INTO empresa VALUES (11,'Galicia');

INSERT INTO manager VALUES (1,100);

--Ex1: Obtenir els identificadors i ciutat de residència dels empleats que treballen per l’empresa ”Bank Newton”
SELECT id_empleat,ciutat from (SELECT * from empleat,feina where empleat.id_empleat=feina.id_empleat) where id_empresa=10;

--Ex2: Obtenir totes les dades dels empeleats que treballen per ”Bank Newton" i guanyen més de 10000
SELECT id_empleat,carrer,ciutat,salari from (SELECT * from empleat,feina where empleat.id_empleat=feina.id_empleat and id_empresa=10) where salari > 10000;



