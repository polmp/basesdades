.mode column
.header on

--usuaris (_id_,nom,grau)

--amistats (_id1_,_id2_)

--preferencies(_id1_, _id2_)

--amistats.sql


--drop table if exists usuaris;
--drop table if exists amistats;
--drop table if exists preferencies;

create table IF NOT EXISTS usuaris(
	ID int, 
	nom text, 
	grau int
);

create table IF NOT EXISTS amistats(
	ID1 int, 
	ID2 int
);

create table IF NOT EXISTS preferencies(
	ID1 int, 
	ID2 int
);

CREATE TABLE IF NOT EXISTS AMICSPOTENCIALS (
	ID1 int,
	ID2 int
);


/*Tasca 1
Escriure un trigger que gestioni una taula d’amicsPotencials, tal que automaticament
quan s’insereixi un usuari, aquest sigui amicPotencial de tot alumne del seu mateix grau.
*/

CREATE TRIGGER T1
AFTER INSERT ON USUARIS
FOR EACH ROW
WHEN EXISTS ( SELECT * FROM USUARIS WHERE grau = new.grau )
BEGIN
	INSERT INTO AMICSPOTENCIALS (ID,new.ID)
end;


SELECT * FROM usuaris;
--SELECT * FROM amistats;
--SELECT * FROM preferencies;
SELECT * FROM AMICSPOTENCIALS;

/*Tasca 2
Escriure un o m ́es triggers per gestionar el grau dels nous usuaris. Si el registre inserit
 ́es inferior a 9 o major a 12, cal canviar el valor a NULL. Addicionalment, si el registre 
 inserit te un valor null a grau, cal canviar-lo per 9.
*/

/*Tasca 3
Escriure un o m ́es triggers que mantinguin la relaci ́o de simetria en amics.  Especıficament
, si s’elimina (A,B) de amistats, aleshores tamb ́e cal eliminar (B,A). Si s’insereix(A,B), 
tamb ́e cal inserir (B,A). No cal mantenir modificacio
ns.
*/

/*Tasca 4
Escriure un trigger que automaticament esborri estudiants quan aquests es graduin, ́es a dir, 
quan el grau superi el valor 12.
*/

/*Tasca 5
Escriure un trigger tal que quan un usuari incrementi un grau, tamb ́e ho facin els seus
amics.
*/

/*Tasca 6
Escriure un trigger que forci el seguent comportament: Si A TÉ preferencia per B, per`o
es modifica a que A t ́e preferencia per C, i B i C s ́on amics, aleshores B i C no poden 
ser amics. Per tant cal eliminar la relaci ́o d’amistat en els 2 sentits (
B,C) i (C,B).
*/

--QUAN SESBORRIN AMICS O USUARIS.... TAMBE SHAN DE BORRAR DE AMICS POTENCIALS,..ETC!





















insert into usuaris values (1510, 'Jordan', 9);
-- insert into usuaris values (1689, 'Gabriel', 9);
-- insert into usuaris values (1381, 'Tiffany', 9);
-- insert into usuaris values (1709, 'Cassandra', 9);
-- insert into usuaris values (1101, 'Haley', 10);
-- insert into usuaris values (1782, 'Andrew', 10);
-- insert into usuaris values (1468, 'Kris', 10);
-- insert into usuaris values (1641, 'Brittany', 10);
-- insert into usuaris values (1247, 'Alexis', 11);
-- insert into usuaris values (1316, 'Austin', 11);
-- insert into usuaris values (1911, 'Gabriel', 11);
-- insert into usuaris values (1501, 'Jessica', 11);
-- insert into usuaris values (1304, 'Jordan', 12);
-- insert into usuaris values (1025, 'John', 12);
-- insert into usuaris values (1934, 'Kyle', 12);
-- insert into usuaris values (1661, 'Logan', 12);

-- insert into amistats values (1510, 1381);
-- insert into amistats values (1510, 1689);
-- insert into amistats values (1689, 1709);
-- insert into amistats values (1381, 1247);
-- insert into amistats values (1709, 1247);
-- insert into amistats values (1689, 1782);
-- insert into amistats values (1782, 1468);
-- insert into amistats values (1782, 1316);
-- insert into amistats values (1782, 1304);
-- insert into amistats values (1468, 1101);
-- insert into amistats values (1468, 1641);
-- insert into amistats values (1101, 1641);
-- insert into amistats values (1247, 1911);
-- insert into amistats values (1247, 1501);
-- insert into amistats values (1911, 1501);
-- insert into amistats values (1501, 1934);
-- insert into amistats values (1316, 1934);
-- insert into amistats values (1934, 1304);
-- insert into amistats values (1304, 1661);
-- insert into amistats values (1661, 1025);
-- insert into amistats select ID2, ID1 from amistats; 

-- insert into preferencies values(1689, 1709);
-- insert into preferencies values(1709, 1689);
-- insert into preferencies values(1782, 1709);
-- insert into preferencies values(1911, 1247);
-- insert into preferencies values(1247, 1468);
-- insert into preferencies values(1641, 1468);
-- insert into preferencies values(1316, 1304);
-- insert into preferencies values(1501, 1934);
-- insert into preferencies values(1934, 1501);
-- insert into preferencies values(1025, 1101);


--SELECT * FROM usuaris;
--SELECT * FROM amistats;
--SELECT * FROM preferencies;
--SELECT * FROM AMICSPOTENCIALS;