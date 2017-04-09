BEGIN TRANSACTION;
CREATE TABLE usuaris (
	email varchar(30) PRIMARY KEY,
	nom varchar(10) not null,
	cognom varchar(12),
	poblacio varchar(12),
	dataNaixement DATETIME,
	pwd varchar(30) not null);
INSERT INTO "usuaris" VALUES('alba@email.com','Alba','Dominguez','Manresa','1969-05-02','passworda');
INSERT INTO "usuaris" VALUES('berto@email.com','Berto','Row','Manresa','1997-12-02','passwordb');
INSERT INTO "usuaris" VALUES('carles@email.com','Carles','Albets','Pamplona','1989-11-12','passwordc');
INSERT INTO "usuaris" VALUES('pere@email.com','Pere','Garcia','Russia','1945-04-5','passwordd');
INSERT INTO "usuaris" VALUES('antoni@email.com','Antoni','Josep','Manresa','1930-04-5','passworde');
CREATE TABLE amistats (
	email1 varchar(30) not null,
	email2 varchar(30) not null,
	estat varchar(12) not null,
	PRIMARY KEY (email1,email2),
	FOREIGN KEY(email1) REFERENCES usuaris(email) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(email2) REFERENCES usuaris(email) ON UPDATE CASCADE ON DELETE CASCADE);
INSERT INTO "amistats" VALUES('alba@email.com','berto@email.com','Acceptada');
INSERT INTO "amistats" VALUES('berto@email.com','carles@email.com','Pendent');
INSERT INTO "amistats" VALUES('pere@email.com','alba@email.com','Acceptada');
INSERT INTO "amistats" VALUES('carles@email.com','pere@email.com','Rebutjada');
INSERT INTO "amistats" VALUES('berto@email.com','pere@email.com','Acceptada');
INSERT INTO "amistats" VALUES('alba@email.com','carles@email.com','Rebutjada');
INSERT INTO "amistats" VALUES('antoni@email.com','berto@email.com','Acceptada');
INSERT INTO "amistats" VALUES('carles@email.com','antoni@email.com','Acceptada');
INSERT INTO "amistats" VALUES('antoni@email.com','alba@email.com','Rebutjada');
INSERT INTO "amistats" VALUES('antoni@email.com','pere@email.com','Acceptada');
COMMIT;