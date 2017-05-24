/* Exercici 2 */

CREATE TABLE IF NOT EXISTS empleat(nemp char(10) PRIMARY KEY, 
	nom char(25),
	sou integer not null);


INSERT OR IGNORE INTO empleat VALUES (1,'Guillem',1000),(2,'Pau',1500),(3,'Pau',5000),(4,'Antonio',5000),(5,'Esteve',5000);
/*Exercici a) Només es pot modificar el sou si el número d'empleats és més gran que 200*/
/* Exercici 2 */

/*Exercici a) Només es pot modificar el sou si el número d'empleats és més gran que 200*/

CREATE TRIGGER IF NOT EXISTS modificar_sou BEFORE UPDATE ON empleat FOR EACH ROW WHEN (new.sou != old.sou) BEGIN
SELECT RAISE(ABORT,'No hi ha suficients usuaris o el sou es massa baix!') WHERE ((SELECT count(*) from EMPLEAT) < 2) or (new.sou < 100);
END;

UPDATE empleat set sou=50 where nom='Guillem';
/*Exercici b) */

CREATE TABLE IF NOT EXISTS tuplesEsborrades(
	dataihora DATETIME,
	numTuples INTEGER
);

CREATE TRIGGER IF NOT EXISTS crea_nou BEFORE DELETE ON empleat FOR EACH ROW WHEN EXISTS (SELECT dataihora from tuplesEsborrades WHERE dataihora=CURRENT_TIMESTAMP) BEGIN
	UPDATE tuplesEsborrades set numTuples=numTuples+1 where dataihora=CURRENT_TIMESTAMP;
END;

CREATE TRIGGER IF NOT EXISTS actualitza_nou BEFORE DELETE ON empleat FOR EACH ROW WHEN NOT EXISTS (SELECT dataihora from tuplesEsborrades WHERE dataihora=CURRENT_TIMESTAMP) BEGIN
	INSERT INTO tuplesEsborrades VALUES (CURRENT_TIMESTAMP,0);
END;

DELETE FROM empleat where sou=5000;