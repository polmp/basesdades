# -*- coding: utf-8 -*-
import sqlite3
import sys
import getpass
import os
import re


def create_backup(cursor,agenda_txt):
	if os.path.isfile(agenda_txt):
		print "L'arxiu existeix! Segur que vols continuar? (Es borrarà tot el contingut) [s/n]"
		if (raw_input()) != 's':
			return False
	cursor.execute("SELECT * from agenda")
	data=cursor.fetchall()
	with open(agenda_txt,'w') as agendatxt:
		for row in data:
			agendatxt.write(row[0]+','+row[1]+','+row[2])
			if row != data[-1]:
				agendatxt.write('\n')

def restore_BD(db,cursor,agendatxt):
	if (not os.path.isfile(agendatxt)):
			print "L'arxiu no existeix!"
			return False
	else:
		print "Segur que vols restaurar (es borrarà tot el que hi havia anteriorment a la BD) [s/n]"
		if (raw_input()) == 's':
			#Comprovacio inicial execucio arxiu
			cursor.executescript("""
				DROP TABLE IF EXISTS agenda;\n
			""")

			cursor.executescript("""
				CREATE TABLE IF NOT EXISTS contacte(
					id INTEGER PRIMARY KEY AUTOINCREMENT,
					nom varchar(20),
					telefon INT
				);
			""")

			db.commit()

			with open(agendatxt) as agendas:
				agenda_row=agendas.read()

			try:
				cur.executemany("INSERT OR IGNORE INTO agenda(id,nom,telefon) VALUES(?, ?, ?)",getTupleDB(agendatxt))
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

#Consultes
#########################################################################################

#Buscar telefon a partir del nom de contacte
def comprovaContacte_Telefon(cursor,nom):
	cursor.execute("""
		SELECT telefon 
		from agenda
		where nom == :name
	""",{'name':nom})
	return cursor.fetchall()

#Buscar contacte a partir del numero de telefon
def comprovaTelefon_Contacte(cursor,telefon):
	cursor.execute("""
	SELECT nom 
	from agenda
	where telefon == :phone
	""",{'phone':telefon})
	return cursor.fetchall()

#Afegeix un contacte a la bd.
def add_Contacte(cursor):
	name=introdueixParametre('Nom')
	phone=introdueixParametre('Telefon')
	cursor.execute("""
		INSERT INTO "agenda" VALUES (?,?)
		""",{name,phone})

#Elimina contacte a partir del nom
def remove_Contacte_byName(db,cursor,nom):
	cursor.execute("""
		DELETE from agenda 
		where nom = :name",
		"""{"name":nom})
	db.commit()

#Eliminca contacte a partir del telefon
def remove_Contacte_byPhone(db,cursor,telefon):
	cursor.execute("""
		DELETE from agenda 
		where telefon = :phone",
		"""{"phone":telefon})
	db.commit()

#########################################################################################




if __name__=='__main__':
	db=sqlite3.connect('agenda.bd')
	cur=db.cursor()
	cur.execute('pragma foreign_keys=ON') #Activem foreign key
	
	if len(sys.argv) == 1:
		print "Executant en mode normal"
		cur.executescript("""
			CREATE TABLE IF NOT EXISTS agenda(
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
				CREATE TABLE IF NOT EXISTS agenda(
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

