.mode column
.header on

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
INSERT INTO amistats ( email1, email2, estat )
			VALUES ('antoni@email.com', 'alba@email.com', 'Rebutjada' );
INSERT INTO amistats ( email1, email2, estat )
			VALUES ('antoni@email.com', 'pere@email.com', 'Acceptada' );