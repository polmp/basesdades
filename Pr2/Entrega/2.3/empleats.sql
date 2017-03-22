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

--Ex1: Obtenir els identificadors i ciutat de residència dels empleats que treballen per l’empresa ”Bank Newton”
--SELECT id_empleat,ciutat from (SELECT * from empleat,feina where empleat.id_empleat=feina.id_empleat) where id_empresa=10;

--Ex2: Obtenir totes les dades dels empeleats que treballen per ”Bank Newton" i guanyen més de 10000
--SELECT id_empleat,carrer,ciutat,salari from (SELECT * from empleat,feina where empleat.id_empleat=feina.id_empleat and id_empresa=10) where salari > 10000;

--Ex3: Obtenir els identificadors dels treballadors que no treballen a ”Bank Newton”
--SELECT id_empleat from (SELECT * from empleat,feina where empleat.id_empleat=feina.id_empleat and id_empresa!=10);

--Ex4: Trobar tots els treballadors que guanyen més que cada empleat de ”Bank Newton”
--FALTA
--SELECT */*id_empleat,carrer,ciutat,salari*/ from  (SELECT max(salari) from feina);
--(SELECT * from empleat,feina where empleat.id_empleat=feina.id_empleat and id_empresa=10) where max(salari) from empleat;

--Ex5: Troba el maxim
--SELECT id_empresa,NombreEmpleats from (SELECT id_empresa,count(id_empleat) as "NombreEmpleats" from (SELECT * from empleat,feina where empleat.id_empleat=feina.id_empleat) group by id_empresa) where NombreEmpleats = (SELECT max(NombreEmpleats) from (SELECT id_empresa,count(id_empleat) as "NombreEmpleats" from (SELECT * from empleat,feina where empleat.id_empleat=feina.id_empleat) group by id_empresa));

--Ex6: Modifica la ciutat de residència de l'empleat 1 a 'Barcelona'

--UPDATE empleat set ciutat = 'Barcelona' where id_empleat=1;
--SELECT ciutat as "Ciutat ID Empleat 1" from empleat where id_empleat=1;

--Ex7: Apuja el sou de tots els empleats coordinadors un 10%
--SELECT id_empleat,salari from feina;
--UPDATE feina set salari=salari*1.10 where id_empleat in (SELECT manager.id_empleat from manager,empleat where manager.id_empleat=empleat.id_empleat);
--SELECT id_empleat,salari from feina;

--Ex8: Troba el nom de tots els empleats que viuen a la mateixa ciutat on treballen
--SELECT id_empleat,ciutat from (SELECT * from empleat,feina,empresa where empleat.id_empleat = feina.id_empleat and feina.id_empresa=empresa.id_empresa and empleat.ciutat = empresa.ciutat);

--Ex9: Troba tots els empleats que viuen a la mateixa ciutat que els seus coordinadors.
--SELECT e1.id_empleat,e1.carrer,e1.ciutat from empleat as e1, empleat as e2,feina,manager where e1.id_empleat != e2.id_empleat and e2.id_empleat == manager.id_empleat_coordinador and e1.ciutat==e2.ciutat group by e1.id_empleat;

--Ex10: Elimina a 'feina' totes les tuples corresponents a empleats que treballin a ”Bank Newton”
-- On id_empresa de Bank Newton -> 10
--DELETE FROM feina where id_empresa=10;
--SELECT * from feina;
