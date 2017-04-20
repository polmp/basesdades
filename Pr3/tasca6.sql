CREATE TABLE IF NOT EXISTS departament (
 	d_num	INT PRIMARY KEY,
 	d_nom	VARCHAR(14) NOT NULL UNIQUE,
 	d_loc	VARCHAR(14),
 );

CREATE TABLE IF NOT EXISTS empleats (
 	e_codi    INT PRIMARY KEY,
 	cognom    VARCHAR (10) NOT NULL,
 	ofici     VARCHAR (10), /*Director, analista, president, empleat, venedor, secretari,.*/
 	data_alta DATETIME,
 	salari    DECIMAL(12,2),
 	comissio  DECIMAL(4,2),
 	
 	d_num	INT,
 	cap 	INT, /*CAP QUE TE EMLEAT*/

	FOREIGN KEY (d_num) REFERENCES departament(d_num),
	FOREIGN KEY (cap) REFERENCES emp(e_codi)
);

CREATE TABLE IF NOT EXISTS client (
 	c_codi	INT(6) PRIMARY KEY,
 	c_nom	VARCHAR (45) NOT NULL,
 	addr	VARCHAR (40) NOT NULL,
 	ciutat	VARCHAR (30) NOT NULL,
 	codi_post VARCHAR (9) NOT NULL,
 	telf	NUMERIC(9,0),
 	lim_cred	DECIMAL(9,2),
 	obs		TEXT,

 	FOREIGN KEY (REPR_COD) REFERENCES emp(EMP_NO)
);


CREATE TABLE IF NOT EXISTS comanda (
 	c_num	INT PRIMARY KEY autoincrement,
	c_data 	DATE,
 	c_tipus VARCHAR(10),
 	c_codi INT (6) NOT NULL,
 	data_tramesa DATETIME,
 	--TOTAL               DECIMAL(8,2),
 	FOREIGN KEY (c_codi) REFERENCES client(c_codi) 
 	CHECK (COM_TIPUS IN ('A','B','C',NULL)
);

CREATE TABLE IF NOT EXISTS producte (
	p_codi  INT (6) PRIMARY KEY,
	descrip	TEXT
);
