# -*- coding: utf-8 -*-
import sqlite3
import sys
import getpass
import os
import re


def create_backup(cursor,contacte_txt):
	if os.path.isfile(contacte_txt) | os.path.isfile(amistats_txt):
		print "Algun arxiu existeix! Segur que vols continuar? (Es borrarà tot el contingut) [s/n]"
		if (raw_input()) != 's':
			return False
	cursor.execute("SELECT * from contacte")
	data=cursor.fetchall()
	with open(contacte_txt,'w') as contactetxt:
		for row in data:
			contactetxt.write(row[0]+','+row[1]+','+row[2])
			if row != data[-1]:
				contactetxt.write('\n')



def restore_BD(db,cursor,contactetxt):
	if (not os.path.isfile(contactetxt)):
			print "L'arxiu no existeix!"
			return False
	else:
		print "Segur que vols restaurar (es borrarà tot el que hi havia anteriorment a la BD) [s/n]"
		if (raw_input()) == 's':
			#Comprovacio inicial execucio arxiu
			cursor.executescript("""
				DROP TABLE IF EXISTS contacte;\n
			""")

			cursor.executescript("""
				CREATE TABLE IF NOT EXISTS contacte(
					id INTEGER PRIMARY KEY AUTOINCREMENT,
					nom varchar(20),
					telefon INT
				);
			""")

			db.commit()

			with open(contactetxt) as contactes:
				contacte_row=contacte.read()

			try:
				cur.executemany("INSERT OR IGNORE INTO contacte(id,nom,telefon) VALUES(?, ?, ?)",getTupleDB(contactetxt))
				db.commit()
				return True
				
			except sqlite3.ProgrammingError as e:
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

#Buscar telefon a partir del nom de contacte
def comprovaContacte_Telefon():

#Buscar contacte a partir del numero de telefon
def comprovaTelefon_Contacte():

#Comprovar quins contactes tenen un numero concret a l'agenda
def comprovaTelefon_Contactes():

#Comprovar quins contactes no tenen un numero concret a l'agenda
def comprovaNoTelefon_Contactes():









if __name__=='__main__':
	db=sqlite3.connect('agenda.bd')
	cur=db.cursor()
	cur.execute('pragma foreign_keys=ON') #Activem foreign key
	
	if len(sys.argv) == 1:
		print "Executant en mode normal"
		cur.executescript("""
			CREATE TABLE IF NOT EXISTS contacte(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				nom varchar(20),
				telefon INT
			);
		""")
		db.commit()

	elif len(sys.argv) == 2:
		print "Carregant arxiu "+sys.argv[1]

		if restore_BD(db,cur,sys.argv[1]):
			print "Restaurat correctament!"
		else:
			print "No s'ha pogut restaurar!"
			cur.executescript("""
				CREATE TABLE IF NOT EXISTS contacte(
					id INTEGER PRIMARY KEY AUTOINCREMENT,
					nom varchar(20),
					telefon INT
				);
			""")
			db.commit()

	elif len(sys.argv) == 3:
		print "Per restaurar necessites 1 txt!"

	try:
		main(db,cur)
		db.close()

	except KeyboardInterrupt:
		print "Sortint..."
		db.close()
		sys.exit(0)

