create table CONTACTES(
	nom VARCHAR(20) not null,
	telf int PRIMARY KEY,
	email varchar(50) not null,
	foto varchar(50),
	check (telf > 100000000 and telf <1000000000)

);
/*
CREATE TRIGGER DUPLICATES 
BEFORE INSERT ON CONTACTES
for each row 
WHEN EXISTS (SELECT * FROM CONTACTES WHERE contactes.telf = New.telf and contactes.nom = New.nom)
BEGIN
	SELECT raise(ignore);
END;


CREATE TRIGGER ERASE
AFTER DELETE ON CONTACTES
FOR EACH ROW
BEGIN
	DELETE FROM CONTACTES
		WHERE contactes.nom = old.nom;
END;
*/
insert into CONTACTES values ('Marc', 666666666,'marc@email.com','')
	,('Albert', 666666667,'albert@email.com','')
	,('Maria', 666666669,'maria@email.com','')
	,('Rosa', 666666656,'rosa@email.com','')
	,('Pol', 666266666,'pol@email.com','')
	,('David', 666566667,'david@email.com','')
	,('Eric', 666656669,'eric@email.com','')
	,('Alex', 666656656,'alex@email.com','')
	,('Marc',777777777,'marc2@email.com','')
	;
