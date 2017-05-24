/* Exercici 2 */

CREATE TABLE IF NOT EXISTS empleat(nemp char(10) PRIMARY KEY, 
	nom char(25),
	sou integer not null);

INSERT OR IGNORE INTO empleat VALUES (1,'Guillem',1000),(2,'Pau',1500);
/*Exercici a) Només es pot modificar el sou si el número d'empleats és més gran que 200*/
/* Exercici 2 */

/*Exercici a) Només es pot modificar el sou si el número d'empleats és més gran que 200*/

CREATE TRIGGER IF NOT EXISTS modificar_sou BEFORE UPDATE ON empleat FOR EACH ROW WHEN (new.sou != old.sou) BEGIN
SELECT RAISE(ABORT,'No hi ha suficients usuaris o el sou es massa baix!') WHERE ((SELECT count(*) from EMPLEAT) < 2) or (new.sou < 100);
END;

/*Exercici b) */

UPDATE empleat set sou=50 where nom='Guillem';
