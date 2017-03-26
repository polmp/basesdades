# -*- coding: utf-8 -*-
import sqlite3
import sys

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

def findByPlace(cursor,place):
	cursor.execute("SELECT * from usuaris where poblacio = :ciutat",{"ciutat":place})
	return cursor.fetchall()

def findFriends(cursor,email):
	cursor.execute("""SELECT nom, cognom  
	FROM amistats,usuaris
	WHERE ((amistats.email1 == :email OR amistats.email2 == :email) AND estat='Acceptada')
		AND ((usuaris.email = amistats.email1) OR (usuaris.email = amistats.email2)) 
		AND usuaris.email != :email""",{"email":email})
	return cursor.fetchall()

def findFriendsByPlace(cursor,place):
	cursor.execute(""" SELECT * 
	FROM amistats, usuaris as u1,usuaris as u2
	WHERE (amistats.email1 == u1.email AND amistats.email2 == u2.email)
		AND amistats.estat == 'Acceptada'
		AND u1.poblacio == :ciutat
		AND u2.poblacio == :ciutat """,{'ciutat':place})
	return cursor.fetchall()

def findTotal(cursor):
	cursor.execute("""
	SELECT count(estat) 
	FROM amistats 
	GROUP BY estat 
	HAVING estat LIKE "%Rebutjada%";
	""")
	return cursor.fetchall()[0][0]

def showExecution(title,values,valuestoshow):
	if len(values) > 0:
 		print title
		print "------------------"
		for row in values:
			for value in valuestoshow:
				if type(value) is list:
					joint=''
					for indval in value:
						joint+=row[indval]+" "
					print joint
				else:
					print row[value]
			print "------------------"
	else:
		print "No s'han trobat resultats!"
		return 0
	return 0



def menu():
	print "1. Buscar usuaris per ciutat"
	print "2. Visualitzar amics d'una persona"
	print "3. Veure total d'amistats rebutjades"
	print "4. Obtenir amics que viuen a una ciutat concreta"
	print "q. Sortir"

def main(cursor):
	while True:
		menu()
		sel=raw_input()
		if sel=='1':
			ciutat = raw_input("Escriu la ciutat: ")
			result=findByPlace(cursor,ciutat)
			showExecution("Usuaris amb residencia "+ciutat,result,[[1,2]])
		elif sel == '2':
			email=raw_input("Escriu el seu email: ")
			result=findFriends(cursor,email)
			showExecution("Amics de "+email,result,[[0,1]])
		elif sel == '3':
			print "El nombre total de peticions rebujades és de "+str(findTotal(cursor))

		elif sel == '4':
			ciutat=raw_input("Escriu la ciutat: ")
			result=findFriendsByPlace(cursor,ciutat)
			showExecution("Amics que viuen a "+ciutat,result,[[4,5],[10,11]])


		elif sel == 'q':
			break
		raw_input()

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

try:
	main(cur)
	db.close()

except KeyboardInterrupt:
	print "Sortint..."
	db.close()
	sys.exit(0)





