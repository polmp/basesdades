import sqlite3

def getTupleDB(txt):
	try:
		arxiu=open(txt)
	except:
		print "No s'ha pogut obrir l'arxiu"
		arxiu.close()
		return []
	else:
		dades=arxiu.read()
		arxiu.close()
		info=[]
		for i in dades.split('\n'):
			infusuari=i.split(',')
			info.append(tuple(infusuari))
		return info

db=sqlite3.connect('xarxsoc.bd')
cur=db.cursor()

"""
CREACIO DE TAULES
"""

cur.executescript("""
	CREATE TABLE IF NOT EXISTS usuaris (
	email varchar(30) PRIMARY KEY,
	nom varchar(10) not null,
	cognom varchar(12),
	poblacio varchar(12),
	dataNaixement DATETIME,
	pwd varchar(30) not null);


	CREATE TABLE IF NOT EXISTS amistats (
	email1 varchar(30) not null,
	email2 varchar(30) not null,
	estat varchar(12) not null,
	PRIMARY KEY (email1,email2));

	""")

#Afegint usuaris
cur.executemany("INSERT OR IGNORE INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) VALUES(?, ?, ?, ?, ?, ?)",getTupleDB('usuarisbd.txt'))
#Afegint amistats
cur.executemany("INSERT OR IGNORE INTO amistats(email1,email2,estat) VALUES (?,?,?)",getTupleDB('amistatsbd.txt'))

db.commit()



