.mode column
.header on

DROP TABLE IF EXISTS usuaris;
DROP TABLE IF EXISTS amistats;

/*
• usuaris(_email_,nom,cognom,poblacio,dataNaixement,pwd)
• amistats(_email1_,_email2_,estat)
*/

CREATE TABLE IF NOT EXISTS usuaris (
	
	email varchar(30) PRIMARY KEY not null,
	nom varchar(10) not null,
	cognom varchar(12),
	poblacio varchar(12),
	dataNaixement DATETIME,
	pwd varchar(30) not null,

	unique(email)

);

CREATE TABLE IF NOT EXISTS amistats (

	email1 varchar(30) PRIMARY KEY not null,
	email2 varchar(30) PRIMARY KEY not null,
	estat varchar(12) not null

);


INSERT INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) 
			VALUES ('alba@email.com', 'Alba', 'aaaa', 'Manresa', '1969-05-02', 'passworda');
INSERT INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) 
			VALUES ('berto@email.com', 'Berto', 'aaaa', 'Manresa', '1997-12-02', 'passwordb');
INSERT INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) 
			VALUES ('carles@email.com', 'Carles', 'Albets', 'Pamplona', '1989-11-12', 'passwordc');

INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'alba@email.com', 'berto@email.com', 'Acceptada' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'berto@email.com', 'carles@email.com', 'Pendent' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'berto@email.com', 'alba@email.com', 'Rebutjada' );


SELECT * FROM usuaris;


--1. Obtenir les dades dels usuaris (excepte pwd) que viuen a Manresa

SELECT nom, email, poblacio, dataNaixement FROM usuaris WHERE poblacio = 'Manresa';

--2. Obtenir l’email dels usuaris amb cognom ”Albets”

SELECT email FROM usuaris WHERE cognom = "Albets";

--3. Visualitzar els amics (nom i cognom) de l’usuari ”Pere”, ”Garcia”(estat=Acceptada)
--4. Obtenir els amics de l’usaris ”Pere””Garcia”que no són amics de l’usuari ”Jordi””Alba”
--5. Obtenir el nombre total de peticions d’amistat rebutjades
--6. Obtenir les dades (noms,cognoms) d’amics que viuen a Manresa
--7. Obtenir, per cada usuari, el nombre de peticions rebutjades
--8. Obtenir els usuaris que no són amics de ”Ana”, ”Vilella”
