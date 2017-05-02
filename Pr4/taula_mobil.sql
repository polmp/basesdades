
CREATE TABLE IF NOT EXISTS cobertura_mobil(
	time_stamp timestamp,
	data datetime,
	lat real,
	lng real,
	signal_inst INT,
	signal_min INT,
	signal_max INT,
	signal_avg INT,
	carrier varchar(20),
	fullCarrier varchar(20),
	status INT,
	net INT,
	net_type varchar(4), --varchar(2)
	lac INT,
	cid INT,
	psc INT,
	speed REAL,
	satellites INT,
	precision1 INT,
	provider varchar(5), --varchar(3)
	activity INT,
	incident varchar(50),
	downloadSpeed REAL,
	uploadSpeed REAL
);

CREATE TABLE IF NOT EXISTS long_lat (
	comunitat varchar(50),
	provincia varchar(50),
	poblacio varchar(50),
	latitud real,
	longitud real,
	altitud real,
	habitants int,
	homes int,
	dones int
);

.mode csv
.separator ","
.import csv/data_export_03-2017.csv cobertura_mobil
.import csv/listado-longitud-latitud-municipios-espana.csv long_lat

.mode column
.header on

DELETE from cobertura_mobil where cid like '%cid%';
DELETE from long_lat where longitud like '%Longitud%';
UPDATE long_lat SET latitud = CAST(replace(latitud, ',', '.') AS REAL) WHERE latitud LIKE '%,%';
UPDATE long_lat SET longitud = CAST(replace(longitud, ',', '.') AS REAL) WHERE longitud LIKE '%,%';
-- Analitzem 500 punts de cobertura mòbil
CREATE VIEW cb as SELECT lat AS LAT_COB,lng AS LONG_COB,fullCarrier,net_type,signal_avg,speed FROM cobertura_mobil limit 500;
-- Seleccionem tots els punts de Catalunya
CREATE VIEW pob as SELECT poblacio,latitud AS LAT_POB,longitud AS LONG_POB FROM long_lat WHERE comunitat like "catalu%";
-- Càlcul per saber zona cobertura-població
SELECT *,abs(cb.LAT_COB-pob.LAT_POB) as distancialat,abs(cb.LONG_COB-pob.LONG_POB) as distancialong,abs(abs(cb.LAT_COB-pob.LAT_POB)+abs(cb.LONG_COB-pob.LONG_POB)) as Distancia from cb,pob order by Distancia;
-- Marquem un llindar de 0.010 (quan la distància sigui més gran no el considerarem que pertany al poble/ciutat)
SELECT * from (SELECT *,net_type as companyia,min(abs(abs(cb.LAT_COB-pob.LAT_POB)+abs(cb.LONG_COB-pob.LONG_POB))) as Distancia from cb,pob group by cb.LAT_COB,cb.LONG_COB order by Distancia ASC) where Distancia < 0.10;
-- Buscar velocitat mitjana de les diferents poblacions
SELECT poblacio,avg(speed),count(speed) from (SELECT *,min(abs(abs(cb.LAT_COB-pob.LAT_POB)+abs(cb.LONG_COB-pob.LONG_POB))) as Distancia from cb,pob group by cb.LAT_COB,cb.LONG_COB order by Distancia ASC) where Distancia < 0.10 group by poblacio;
-- Buscar les companyies més i menys distribuïdes en una població
SELECT poblacio,max(fullCarrier),min(fullCarrier) from (SELECT *,min(abs(abs(cb.LAT_COB-pob.LAT_POB)+abs(cb.LONG_COB-pob.LONG_POB))) as Distancia from cb,pob group by cb.LAT_COB,cb.LONG_COB order by Distancia ASC) where Distancia < 0.10 group by poblacio;