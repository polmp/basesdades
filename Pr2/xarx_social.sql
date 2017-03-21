.mode column
.header on

DROP TABLE IF EXISTS usuaris;
DROP TABLE IF EXISTS amistats;

/*
• usuaris(_email_,nom,cognom,poblacio,dataNaixement,pwd)
• amistats(_email1_,_email2_,estat)
*/

CREATE TABLE IF NOT EXISTS usuaris (
	
	email varchar(30) PRIMARY KEY,
	nom varchar(10) not null,
	cognom varchar(12),
	poblacio varchar(12),
	dataNaixement DATETIME,
	pwd varchar(30) not null

);

CREATE TABLE IF NOT EXISTS amistats (
	email1 varchar(30) not null,
	email2 varchar(30) not null,
	estat varchar(12) not null,
	PRIMARY KEY (email1,email2)

);


INSERT INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) 
			VALUES ('alba@email.com', 'Alba', 'Dominguez', 'Manresa', '1969-05-02', 'passworda');
INSERT INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) 
			VALUES ('berto@email.com', 'Berto', 'Row', 'Manresa', '1997-12-02', 'passwordb');
INSERT INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) 
			VALUES ('carles@email.com', 'Carles', 'Albets', 'Pamplona', '1989-11-12', 'passwordc');
INSERT INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) 
			VALUES ('pere@email.com', 'Pere', 'Garcia', 'Russia', '1945-04-5', 'passwordd');
INSERT INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) 
			VALUES ('antoni@email.com', 'Antoni', 'Josep', 'Manresa', '1930-04-5', 'passworde');

INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'alba@email.com', 'berto@email.com', 'Acceptada' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'berto@email.com', 'carles@email.com', 'Pendent' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'pere@email.com', 'alba@email.com', 'Acceptada' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'carles@email.com','pere@email.com', 'Rebutjada' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'berto@email.com', 'pere@email.com', 'Acceptada' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'alba@email.com', 'carles@email.com', 'Rebutjada' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'antoni@email.com', 'berto@email.com', 'Acceptada' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'carles@email.com', 'antoni@email.com', 'Acceptada' );
/*INSERT INTO amistats ( email1, email2, estat )
			VALUES ( 'antoni@email.com', 'alba@email.com', 'Acceptada' );*/

/*
SELECT * FROM usuaris;
SELECT * from amistats;

*/
/*

--1. Obtenir les dades dels usuaris (excepte pwd) que viuen a Manresa
	
	SELECT nom, email, poblacio, dataNaixement 
	FROM usuaris 
	WHERE poblacio = 'Manresa';

--2. Obtenir l’email dels usuaris amb cognom ”Albets”
	
	SELECT email 
	FROM usuaris 
	WHERE cognom = "Albets";

--3. Visualitzar els amics (nom i cognom) de l’usuari ”Pere”, ”Garcia”(estat=Acceptada)
	
	SELECT nom, cognom  
	FROM amistats,usuaris
	WHERE ((amistats.email1 == 'pere@email.com' OR amistats.email2 == 'pere@email.com') AND estat='Acceptada')
		AND ((usuaris.email = amistats.email1) OR (usuaris.email = amistats.email2)) 
		AND usuaris.email != 'pere@email.com'
	;
--4. Obtenir els amics de l’usaris ”Berto”””que no són amics de l’usuari ”Alba"
SELECT * from (SELECT * from usuaris INNER JOIN amistats on email=email1 UNION SELECT * from usuaris INNER JOIN amistats on email=email2) where email1='alba@email.com' or email2='alba@email.com' or email1='berto@email.com' or email2='berto@email.com';

	--Millorat pero encara no em funca.
	SELECT nom, cognom 
	FROM usuaris, amistats
	WHERE ((amistats.email1 == 'pere@email.com' OR amistats.email2=='pere@email.com') AND estat=='Acceptada')
		AND (usuaris.email = amistats.email1 OR usuaris.email = amistats.email2) 
		AND usuaris.email != 'pere@email.com'
	EXCEPT 
	SELECT nom,cognom 
	FROM usuaris,amistats
	WHERE ((amistats.email1=='alba@email.com' OR amistats.email2=='alba@email.com') AND estat=='Acceptada')
		AND (usuaris.email = amistats.email1 OR usuaris.email = amistats.email2) 
	;

/*--5. Obtenir el nombre total de peticions d’amistat rebutjades
	
	SELECT count(estat) 
	FROM amistats 
	GROUP BY estat 
	HAVING estat LIKE "%Rebutjada%";

--6. Obtenir les dades (noms,cognoms) d’amics que viuen a Manresa

	
	SELECT * 
	FROM amistats, usuaris as u1,usuaris as u2
	WHERE (amistats.email1 == u1.email AND amistats.email2 == u2.email)
		AND amistats.estat == 'Acceptada'
		AND u1.poblacio == 'Manresa'
		AND u2.poblacio == 'Manresa'
	;

--7. Obtenir, per cada usuari, el nombre de peticions rebutjades
	
	SELECT email1,count(Rebutjat) as "NombreRebutjats" from (SELECT email1,count(estat) as "Rebutjat" from amistats group by email1,email2 having estat like "%Rebutjada%" UNION ALL SELECT email2,count(estat) from amistats group by email1,email2 having estat like "%Rebutjada%") group by email1;

--8. Obtenir els usuaris que no són amics de ”Alba”, ”Vilella”

	SELECT email  
	FROM amistats,usuaris
	WHERE ((amistats.email1 == 'alba@email.com' OR amistats.email2 == 'alba@email.com') AND estat!='Acceptada')
		AND ((usuaris.email = amistats.email1) OR (usuaris.email = amistats.email2)) 
		AND usuaris.email != 'alba@email.com'
	;
*/