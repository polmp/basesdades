.mode column
.header on

create table CONTACTES(
	nom VARCHAR(20),
	telf int,
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


insert into CONTACTES values ('Marc', 666666666)
	,('Albert', 666666667)
	,('Maria', 666666669)
	,('Rosa', 666666656)
	,('Pol', 666266666)
	,('David', 666566667)
	,('Eric', 666656669)
	,('Alex', 666656656);

SELECT * FROM CONTACTES;

insert into CONTACTES values ('Marc', 666666666);

SELECT * FROM CONTACTES ORDER BY nom; --ORDENAT PER NOM DE CONTACTE