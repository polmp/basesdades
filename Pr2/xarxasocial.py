# -*- coding: utf-8 -*-
import sqlite3
import sys
import getpass
import os
import re
import datetime

def create_backup(cursor,filetxt):
	if os.path.isfile(filetxt):
		print "L'arxiu existeix! Segur que vols continuar? (Es borrarà el seu contingut) [s/n]"
		if (raw_input()) != 's':
			return False
	data = '\n'.join(cursor.iterdump())
	with open(filetxt,'w') as f:
		f.write(data)
	return True

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
		datetime.datetime.strptime(date, '%Y-%m-%d')
		return True
	except ValueError:
		return False


def checkemail(email):

	try:
		if re.match("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",email):
			return True
		else:
			return False
	except:
			return False

def checkSql(txtfile):
	for i in txtfile[:txtfile.find('.')]:
		if (not i.isalpha()) & (not i.isdigit()) & (i!='_'):
			return False
	return txtfile[txtfile.find('.')+1:] == 'sql'

def comprovaParametre(nompar,hidefield=False,can_be_empty=False,funcio=None):
	if not hidefield:
		variable=raw_input("Introdueix el parametre "+nompar+": ")
	else:
		variable=getpass.getpass("Introdueix el "+nompar+": ")

	if len(variable) == 0:
		if can_be_empty:
			return ''
		else:
			return False
	else:
		if funcio is not None:
			if funcio(variable):
				return variable
			else:
				return False
		return variable

def restore_BD(cursor,filetorestore):
	if not os.path.isfile(filetorestore):
			print "L'arxiu no existeix!"
			return False
	else:
		print "L'arxiu ja existeix! Segur que vols restaurar (es borrarà tot el que hi havia anteriorment) [s/n]"
		if (raw_input()) == 's':
			cur.executescript("""DROP TABLE IF EXISTS usuaris;\n
					DROP TABLE IF EXISTS amistats;""")
			with open(filetorestore) as f:
				scriptsql=f.read()
			try:
				cur.executescript(scriptsql)
				return True
			except sqlite3.OperationalError as e:
				print "Error! "+str(e)
				return False
		else:
			print "Restauració cancelada"
			return False


def introdueixParametre(nompar,hidefield=False,can_be_empty=False,funcio=None):
	par=comprovaParametre(nompar,hidefield,can_be_empty,funcio)
	while not par:
		if par == '':
			break
		par=comprovaParametre(nompar,hidefield,can_be_empty,funcio)
	return par

def update_row(db,cursor,email,parametertoupdate):
	sentencesql= ''' UPDATE usuaris set '''
	for parameter in parametertoupdate.keys():
		sentencesql+=parameter+'='+'?'
		if parameter != parametertoupdate.keys()[-1]:
			sentencesql+=','
		else:
			sentencesql+=" where email='"+str(email)+"'"
	print "Executant..."
	print sentencesql
	cur.execute(sentencesql,tuple(parametertoupdate.values()))
	db.commit()

def email_exists_in_db(cursor,email):
	cursor.execute('SELECT * from usuaris where email = ?',(email,))
	dades=cursor.fetchone()
	if dades is None:
		return False
	else:
		return True
	
def menu():
	print "1. Buscar usuaris per ciutat"
	print "2. Visualitzar amics d'una persona"
	print "3. Veure total d'amistats rebutjades"
	print "4. Obtenir amics que viuen a una ciutat concreta"
	print "5. Obtenir peticions rebutjades per usuari"
	print "6. Obtenir amics que no son amic de X persona"
	print "7. Afegir usuari"
	print "8. Editar usuari"
	print "9. Crear copia de seguretat"
	print "10. Restaurar copia de seguretat"
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
			ciutat=raw_input("Escriu la ciutat: ")
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
			email=introdueixParametre('email',False,False,checkemail)
			if email_exists_in_db(cursor,email):
				print "L'usuari ja existeix!"
			else:
				nom=introdueixParametre('nom')
				cognom=introdueixParametre('cognom')
				ciutat=introdueixParametre('ciutat')
				print "Format data: YYYY-MM-DD"
				data=introdueixParametre('data',False,False,checkdate)
				password=introdueixParametre('password',True)
				cur.execute("""INSERT INTO "usuaris" VALUES (?,?,?,?,?,?)""",(email,nom,cognom,ciutat,data,password))
				db.commit()
				print "Usuari afegit corretament"
		elif sel == '8':
			infotoupdate={}
			print "Primer introdueix el email del usuari"
			email=introdueixParametre('email',False,False,checkemail)
			if not email_exists_in_db(cursor,email):
				print "L'usuari no existeix!"
			else:
				cursor.execute('SELECT * from usuaris where email = ?',(email,))
				dades=cursor.fetchone()
				print "------------------------------------------------------------------"
				print "Si no vols modificar un paràmetre deixa el camp buit"
				print "------------------------------------------------------------------"
				print "Paràmetre actual de nom: "+str(dades[1])
				nom=introdueixParametre('nom',False,True)
				if nom != '':
					infotoupdate['nom'] = nom
				print "Paràmetre actual de cognom: "+str(dades[2])
				cognom=introdueixParametre('cognom',False,True)
				if cognom != '':
					infotoupdate['cognom'] = cognom
				print "Paràmetre actual de ciutat: "+str(dades[3])
				poblacio=introdueixParametre('poblacio',False,True)
				if poblacio != '':
					infotoupdate['poblacio'] = poblacio
				print "Paràmetre actual de data: "+str(dades[4])
				print "Format data: YYYY-MM-DD"
				dataNaixement=introdueixParametre('dataNaixement',False,True,checkdate)
				if dataNaixement != '':
					infotoupdate['dataNaixement'] = dataNaixement
				print "Paràmetre actual de password: OCULT"
				password=introdueixParametre('password',True,True)
				if password != '':
					infotoupdate['pwd'] = password
				if len(infotoupdate) > 0:
					update_row(db,cursor,email,infotoupdate)
				else:
					print "No has afegit parametres per editar!"

		elif sel == '9':
			print "Introdueix el nom de la base de dades (nom.sql)"
			nomarxiu=introdueixParametre('nomarxiu',False,False,checkSql)
			if create_backup(db,nomarxiu):
				print "Backup guardada a "+nomarxiu+" correctament"
			else:
				print "No s'ha creat la còpia de seguretat"
				

		elif sel == '10':
			print "Introdueix el nom de la base de dades (nom.sql)"
			nomarxiu=introdueixParametre('nomarxiu',False,False,checkSql)
			if restore_BD(cursor,nomarxiu):
				print "Restaurat correctament!"
			else:
				print "No s'ha pogut restaurar!"

		elif sel == 'q':
			break
		raw_input()

if __name__=='__main__':
	"""

	#CREACIO DE TAULES

	# cur.executescript("""
	#	CREATE TABLE IF NOT EXISTS usuaris (
	#	email varchar(30) PRIMARY KEY,
	#	nom varchar(10) not null,
	#	cognom varchar(12),
	#	poblacio varchar(12),
	#	dataNaixement DATETIME,
	#	pwd varchar(30) not null);


	#	CREATE TABLE IF NOT EXISTS amistats (
	#	email1 varchar(30) not null,
	#	email2 varchar(30) not null,
	#	estat varchar(12) not null,
	#	PRIMARY KEY (email1,email2));

	#	""")
	"""

	#Afegint usuaris
	cur.executemany("INSERT OR IGNORE INTO usuaris(email,nom,cognom,poblacio,dataNaixement,pwd) VALUES(?, ?, ?, ?, ?, ?)",getTupleDB('usuarisbd.txt'))
	#Afegint amistats
	cur.executemany("INSERT OR IGNORE INTO amistats(email1,email2,estat) VALUES (?,?,?)",getTupleDB('amistatsbd.txt'))
	db.commit()

	"""

	db=sqlite3.connect('xarxsoc.bd')
	cur=db.cursor()
	if len(sys.argv) == 1:
		print "Executant en mode normal"

	elif len(sys.argv) == 2:
		print "Carregant arxiu "+sys.argv[1]
		if restore_BD(cur,sys.argv[1]):
			print "Restaurat correctament!"
		else:
			print "No s'ha pogut restaurar!"


	try:
		main(db,cur)
		db.close()

	except KeyboardInterrupt:
		print "Sortint..."
		db.close()
		sys.exit(0)





