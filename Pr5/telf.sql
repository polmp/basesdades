.mode column
.header on

create table CONTACTES(
	nom VARCHAR(20),
	telf int,
	email varchar(50),
	foto text, --NPI DEL FORMAT
	check (telf > 100000000 and telf <1000000000)

);


--AVOID DUPLICATES
CREATE TRIGGER DUPLICATES 
BEFORE INSERT ON CONTACTES
for each row 
WHEN EXISTS (SELECT * FROM CONTACTES WHERE contactes.telf = New.telf and contactes.nom = New.nom)
BEGIN
	SELECT raise(ignore);
END;

--TASCA 7 DE ELIMINAR TOTS ELS USUARIS QUE TENEN EL NOM DE *
CREATE TRIGGER ERASE
AFTER DELETE ON CONTACTES
FOR EACH ROW
BEGIN
	DELETE FROM CONTACTES
		WHERE contactes.nom = old.nom;
END;

insert into CONTACTES values ('Marc', 666666666,'','')
	,('Albert', 666666667,'','')
	,('Maria', 666666669,'','')
	,('Rosa', 666666656,'','')
	,('Pol', 666266666,'','')
	,('David', 666566667,'','')
	,('Eric', 666656669,'','')
	,('Alex', 666656656,'','')
	,('Marc',777777777,'','')
	;

SELECT * FROM CONTACTES ORDER BY nom;

insert into CONTACTES values ('Marc', 666666666,'','');

SELECT * FROM CONTACTES ORDER BY nom; --ORDENAT PER NOM DE CONTACTE

DELETE FROM CONTACTES WHERE NOM = 'Marc';

SELECT * FROM CONTACTES ORDER BY nom; --ORDENAT PER NOM DE CONTACTE


--TASCA 8
UPDATE CONTACTES
	SET telf = 123456789 --VALOR A CANVIAR
		WHERE nom = '???' and telf = 741852963; --I MISSATGE... CONTACTE MODIFICAT!