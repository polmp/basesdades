CREATE TABLE IF NOT EXISTS Cataleg(
	NumCataleg INTEGER PRIMARY KEY,
	DataEdicio DATETIME,
	PeriodVig DATETIME,
	NumPag INTEGER,
	NumExemp INTEGER);

CREATE TABLE IF NOT EXISTS Producte(CodiProd INTEGER PRIMARY KEY,Descripcio VARCHAR);

CREATE TABLE IF NOT EXISTS Magatzem(
	NomMag VARCHAR,
	Adreça VARCHAR,
	Telefon INTEGER,
	NomEmpr VARCHAR,
	PRIMARY KEY(NomMag),

	FOREIGN KEY (NomEmpr) REFERENCES Empresa(NomEmpr) -- Referencia empresa

	);

CREATE TABLE IF NOT EXISTS Empresa(NomEmpr VARCHAR PRIMARY KEY,Adreça VARCHAR);


CREATE TABLE IF NOT EXISTS Conductor(
	DniConductor VARCHAR PRIMARY KEY,
	Telef INTEGER,
	NomEmpr VARCHAR,
	FOREIGN KEY (NomEmpr) REFERENCES Empresa(NomEmpr) --Referencia conductor/empresa
	);


CREATE TABLE IF NOT EXISTS Client(
	DniClient VARCHAR PRIMARY KEY,
	Nom VARCHAR,
	Adreça VARCHAR,
	NomEmpr VARCHAR,
	FOREIGN KEY (NomEmpr) REFERENCES Empresa(NomEmpr)
	);


CREATE TABLE IF NOT EXISTS ClientPotencial(
	DniClient VARCHAR,
	NumVeg INT,
	PRIMARY KEY(DniClient),
	FOREIGN KEY (DniClient) REFERENCES Client(DniClient)
	);
-- Subclasse:
-- Hem d'afegir els atributs de la clau primària de la superclasse
-- I la referenciem

CREATE TABLE IF NOT EXISTS ClientReal(
	DniClient VARCHAR,
	Tel INT,
	NomMag VARCHAR, --Referencia magatzem
	PRIMARY KEY (DniClient),
	FOREIGN KEY (DniClient) REFERENCES Client(DniClient),
	FOREIGN KEY(NomMag) REFERENCES Magatzem(NomMag) 
);

CREATE TABLE IF NOT EXISTS Comandes(
	NumCom INT PRIMARY KEY,
	NumCataleg INT not null,
	Data DATETIME,
	DniClient VARCHAR,--Referencia ClientReal
	NomMag VARCHAR, -- Referencia magatzem

	/*FALTA Un paràmetre enviament NumEnviament INT*/
	FOREIGN KEY(DniClient) REFERENCES ClientReal(DniClient),
	FOREIGN KEY(NomMag) REFERENCES Magatzem(NomMag), --Ref magatzem
	FOREIGN KEY(NumCataleg) REFERENCES Cataleg(NumCataleg) --Ref cataleg
);

CREATE TABLE IF NOT EXISTS Xec(
	NumBanc VARCHAR,
	NumAgenc VARCHAR,
	NumCompte VARCHAR,
	Import REAL,
	CobratSiNo BIT,
	NumCom INT,--De la superclasse
	PRIMARY KEY(NumCom),
	FOREIGN KEY(NumCom) REFERENCES Comandes(NumCom)
);

CREATE TABLE IF NOT EXISTS Efectiu(
	Import REAL,
	NumCom INT,--De la superclasse
	PRIMARY KEY(NumCom),
	FOREIGN KEY(NumCom) REFERENCES Comandes(NumCom)
);
	

CREATE TABLE IF NOT EXISTS ProducteCataleg(
	NumCataleg INT,
	CodiProd INT,
	Preu_Producte INT,
	PRIMARY KEY(NumCataleg,CodiProd),
	FOREIGN KEY (CodiProd) REFERENCES Producte(CodiProd),
	FOREIGN KEY (NumCataleg) REFERENCES Cataleg(NumCataleg)
); --Relació Catàleg - Producte


CREATE TABLE IF NOT EXISTS Inventari(
	CodiProd INT,
	NomMag VARCHAR,
	Quantitat_Stock_Producte INT,
	PRIMARY KEY(CodiProd,NomMag),
	FOREIGN KEY (CodiProd) REFERENCES Producte(CodiProd),
	FOREIGN KEY (NomMag) REFERENCES Magatzem(NomMag)
); --Relació Producte - Magatzem
/*
Empreses_Magatzem(NomMag VARCHAR PRIMARY KEY,NomEmpr VARCHAR PRIMARY KEY); -- Relació Magatzem - Empresa


Flota(DniConductor VARCHAR PRIMARY KEY,NomMag VARCHAR PRIMARY KEY,Data DATETIME PRIMARY KEY);
Llista_Conductors(DNI VARCHAR PRIMARY KEY,NomEmpr VARCHAR PRIMARY KEY);
Clientela(NomEmpr VARCHAR PRIMARY KEY,DniClient VARCHAR PRIMARY KEY);

*/