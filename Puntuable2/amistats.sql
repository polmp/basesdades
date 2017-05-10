drop table if exists usuaris;
drop table if exists amistats;
drop table if exists preferencies;

create table usuaris(ID int, nom text, grau int);
create table amistats(ID1 int, ID2 int);
create table preferencies(ID1 int, ID2 int);
create table amicsPotencials(ID1 int,ID2);



insert or ignore into usuaris values (1510, 'Jordan', 9);
insert or ignore into usuaris values (1689, 'Gabriel', 9);
insert or ignore into usuaris values (1381, 'Tiffany', 9);
insert or ignore into usuaris values (1709, 'Cassandra', 9);
insert or ignore into usuaris values (1101, 'Haley', 10);
insert or ignore into usuaris values (1782, 'Andrew', 10);
insert or ignore into usuaris values (1468, 'Kris', 10);
insert or ignore into usuaris values (1641, 'Brittany', 10);
insert or ignore into usuaris values (1247, 'Alexis', 11);
insert or ignore into usuaris values (1316, 'Austin', 11);
insert or ignore into usuaris values (1911, 'Gabriel', 11);
insert or ignore into usuaris values (1501, 'Jessica', 11);
insert or ignore into usuaris values (1304, 'Jordan', 12);
insert or ignore into usuaris values (1025, 'John', 12);
insert or ignore into usuaris values (1934, 'Kyle', 12);
insert or ignore into usuaris values (1661, 'Logan', 12);

insert or ignore into amistats values (1510, 1381);
insert or ignore into amistats values (1510, 1689);
insert or ignore into amistats values (1689, 1709);
insert or ignore into amistats values (1381, 1247);
insert or ignore into amistats values (1709, 1247);
insert or ignore into amistats values (1689, 1782);
insert or ignore into amistats values (1782, 1468);
insert or ignore into amistats values (1782, 1316);
insert or ignore into amistats values (1782, 1304);
insert or ignore into amistats values (1468, 1101);
insert or ignore into amistats values (1468, 1641);
insert or ignore into amistats values (1101, 1641);
insert or ignore into amistats values (1247, 1911);
insert or ignore into amistats values (1247, 1501);
insert or ignore into amistats values (1911, 1501);
insert or ignore into amistats values (1501, 1934);
insert or ignore into amistats values (1316, 1934);
insert or ignore into amistats values (1934, 1304);
insert or ignore into amistats values (1304, 1661);
insert or ignore into amistats values (1661, 1025);
insert or ignore into amistats select ID2, ID1 from amistats; 

insert or ignore into preferencies values(1689, 1709);
insert or ignore into preferencies values(1709, 1689);
insert or ignore into preferencies values(1782, 1709);
insert or ignore into preferencies values(1911, 1247);
insert or ignore into preferencies values(1247, 1468);
insert or ignore into preferencies values(1641, 1468);
insert or ignore into preferencies values(1316, 1304);
insert or ignore into preferencies values(1501, 1934);
insert or ignore into preferencies values(1934, 1501);
insert or ignore into preferencies values(1025, 1101);

/*Tasca 1 Escriure un trigger que gestioni una taula d'amicsPotencials, tal que automàticament quan s’insereixi un usuari, aquest sigui amicPotencial de tot alumne del seu mateix grau. */
CREATE TRIGGER IF NOT EXISTS afegeix_amicspotencials AFTER INSERT ON usuaris BEGIN
INSERT INTO amicsPotencials SELECT NEW.ID,ID from usuaris where NEW.nom != usuaris.nom and NEW.grau=grau;
END;

/*Tasca 2: Escriure un o més triggers per gestionar el grau dels nous usuaris. Si el registre inserit és 
inferior a 9 o major a 12, cal canviar el valor a NULL. Addicionalment, si el registre inserit té un valor null a grau, cal canviar-lo per 9.*/
CREATE TRIGGER IF NOT EXISTS canvia_grau_null AFTER INSERT ON USUARIS WHEN NEW.grau < 9 or NEW.grau > 12 BEGIN
UPDATE usuaris set grau = null WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS canvia_grau_9 AFTER INSERT ON USUARIS WHEN NEW.grau is null BEGIN
UPDATE usuaris set grau = 9 WHERE id = NEW.id;
END;

/*Tasca 3: Escriure un o més triggers que mantinguin la relació de simetria en amics. 
Específicament, si s'elimina (A,B) de amistats, aleshores també cal eliminar (B,A). Si s'insereix (A,B), també cal inserir (B,A). 
No cal mantenir modificacions.*/

CREATE TRIGGER IF NOT EXISTS afegeix_simetria AFTER INSERT ON amistats BEGIN
INSERT OR IGNORE INTO amistats values (NEW.ID2,NEW.ID1);
END;

CREATE TRIGGER IF NOT EXISTS borra_simetria DELETE ON amistats BEGIN
DELETE FROM amistats where ID1=OLD.ID2 and ID2=OLD.ID1;
END;

/*Tasca 4: Escriure un trigger que automàticament esborri estudiants quan aquests es graduin, és a dir, quan el grau superi el valor 12.*/
CREATE TRIGGER IF NOT EXISTS borra_estudiant UPDATE ON usuaris WHEN NEW.grau > 12 BEGIN
DELETE FROM usuaris WHERE NEW.grau > 12 and id=NEW.id;
END;

/*Tasca 5: Escriure un trigger tal que quan un usuari incrementi un grau, també ho facin els seus amics.*/
CREATE TRIGGER IF NOT EXISTS incrementa_grau AFTER UPDATE ON usuaris WHEN NEW.grau = OLD.grau+1 BEGIN
UPDATE usuaris set grau=grau+1 WHERE ID IN (SELECT ID1 from amistats where ID2 = NEW.ID);
END;

/*Tasca 6: Escriure un trigger que forci el següent comportament: Si A té preferència per B, però es modifica a que A té preferència per C,
i B i C són amics, aleshores B i C no poden ser amics. Per tant cal eliminar la relació d'amistat en els 2 sentits (B,C) i (C,B).*/


CREATE TRIGGER IF NOT EXISTS borra_amics_preferencia BEFORE UPDATE ON preferencies BEGIN
DELETE FROM amistats where (ID1=OLD.ID2 and ID2=NEW.ID2) OR (ID1=NEW.ID2 and ID2=OLD.ID2);
END;

/*Prova 6*/
/*
INSERT INTO amistats VALUES (1709,1641);
SELECT * from amistats where ID1=1641 and ID2=1709;
SELECT * from amistats;
SELECT 'END';

UPDATE preferencies set ID2=1641 where ID1=1689 and ID2=1709;

SELECT * from amistats;
*/






