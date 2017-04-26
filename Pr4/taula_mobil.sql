CREATE TABLE IF NOT EXISTS cobertura_mobil(
	time_stamp timestamp,
	data datetime,
	lat REAL,
	lng REAL,
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

DELETE from cobertura_mobil where cid like '%cid%';

DELETE from long_lat where longitud like '%Longitud%';


