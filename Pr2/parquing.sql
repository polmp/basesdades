CREATE TABLE IF NOT EXISTS parquing (
	matricula char(30) PRIMARY KEY,
	plasa INT not null unique,
	data DATETIME,
	color TEXT,
	model TEXT,
)