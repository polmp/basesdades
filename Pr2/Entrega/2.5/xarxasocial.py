# -*- coding: utf-8 -*-
import sqlite3
import sys
import getpass
import os
import re

def create_backup(cursor,filetxt):
	cursor.fetchall('SELECT * from usuaris')
	print cursor

def getTupleDB(txt):
	with open(txt) as arxiu:
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

def findRebByUser(cursor):
	cursor.execute("""SELECT email1,count(Rebutjat) as "NombreRebutjats" from (SELECT email1,count(estat) as "Rebutjat" from amistats group by email1,email2 having estat like "%Rebutjada%" UNION ALL SELECT email2,count(estat) from amistats group by email1,email2 having estat like "%Rebutjada%") group by email1;""")
	return cursor.fetchall()

def findNotFriendsOf(cursor,mail):
	cursor.execute(""" SELECT email  
	FROM amistats,usuaris
	WHERE ((amistats.email1 == :email OR amistats.email2 == :email) AND estat!='Acceptada')
		AND ((usuaris.email = amistats.email1) OR (usuaris.email = amistats.email2)) 
		AND usuaris.email != :email
	;""",{'email':mail})
	return cursor.fetchall()

def addUser(email,nom,cognom,poblacio,data,contrasenya):
	pass


def showExecution(title,values,valuestoshow):
	if len(values) > 0:
 		print title
		print "----------------------------------"
		for row in values:
			for value in valuestoshow:
				if type(value) is list:
					joint=''
					for indval in value:
						joint+=str(row[indval])+" "
					print joint
				else:
					print str(row[value])
			print "----------------------------------"
	else:
		print "No s'han trobat resultats!"
		return 0
	return 0

def checkdate(date):

	try:
		if re.match('^(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)\d\d$',date):
			return True
		else:
			return False

	except:
			return False


def checkemail(email):

	try:
		if re.match("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",email):
			return True
		else:
			return False
	except:
			return False




def checkTxt(txtfile):
	for i in txtfile[:txtfile.find('.')]:
		if (not i.isalpha()) & (not i.isdigit()):
			return False
	return txtfile[txtfile.find('.')+1:] == 'txt'

def comprovaParametre(nompar,hidefield=False,funcio=None):
	if not hidefield:
		variable=raw_input("Introdueix el parametre "+nompar+": ")
	else:
		variable=getpass.getpass("Introdueix el "+nompar+": ")

	try:
		assert variable!= '',nompar
	except AssertionError:
		print "Afegeix el parametre "+nompar+" correctament"
		return False
	else:
		if funcio is not None:
			if funcio(variable):
				return True
			else:
				return False
		return True



def introdueixParametre(nompar,hidefield=False,funcio=None):
	par=comprovaParametre(nompar,hidefield,funcio)
	while not par:
		par=comprovaParametre(nompar,hidefield,funcio)
	return par
		



def menu():
	print "1. Buscar usuaris per ciutat"
	print "2. Visualitzar amics d'una persona"
	print "3. Veure total d'amistats rebutjades"
	print "4. Obtenir parelles de amics que viuen a una ciutat concreta"
	print "5. Obtenir peticions rebutjades per usuari"
	print "6. Obtenir amics que no son amic de X persona"
	print "7. Afegir usuari"
	print "8. Crear copia de seguretat"
	print "q. Sortir"

def main(db,cursor):
	while True:
		menu()
		sel=raw_input()
		if sel=='1':
			ciutat = raw_input("Escriu la ciutat: ").title()
			result=findByPlace(cursor,ciutat)
			showExecution("Usuaris amb residencia "+ciutat,result,[[1,2]])
		elif sel == '2':
			email=raw_input("Escriu el seu email: ").lower()
			result=findFriends(cursor,email)
			showExecution("Amics de "+email,result,[[0,1]])
		elif sel == '3':
			print "El nombre total de peticions rebujades és de "+str(findTotal(cursor))

		elif sel == '4':
			ciutat=raw_input("Escriu la ciutat: ").title()
			result=findFriendsByPlace(cursor,ciutat)
			showExecution("Amics que viuen a "+ciutat,result,[[4,5],[10,11]])

		elif sel == '5':
			result=findRebByUser(cursor)
			showExecution("Total amistats rebujades",result,[[0,1]])

		elif sel == '6':
			email=raw_input("Escriu el seu email: ").lower()
			result=findNotFriendsOf(cursor,email)
			showExecution("Amics que no son de "+email,result,[[0]])

		elif sel == '7':
			email=introdueixParametre('email',False,checkemail)
			nom=introdueixParametre('nom')
			cognom=introdueixParametre('cognom')
			data=introdueixParametre('data',False,checkdate)
			password=introdueixParametre('password',True)
			print "Usuari afegit corretament"

		elif sel == '8':
			nomarxiu=introdueixParametre('nom arxiu',False,checkTxt)
			if os.path.isfile(nomarxiu):
				print "L'arxiu ja existeix! Vols continuar [s/n]"
				if (raw_input().lower()) == 's':
					create_backup(db,nomarxiu)
			else:
				create_backup(db,nomarxiu)

		elif sel == 'q':
			break
		raw_input()

if __name__=='__main__':
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

	data = '\n'.join(db.iterdump())
	print data
	try:
		main(db,cur)
		db.close()

	except KeyboardInterrupt:
		print "Sortint..."
		db.close()
		sys.exit(0)





