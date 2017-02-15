#!/usr/bin/env python
# -*- coding: utf-8 -*-

def init():
	f=open('places.dat','w+')
	for i in range(0,1001):
		f.write('XXXXXXX')
		if i != 1000:
			f.write(' ')
	f.close()

def optionsProg():
	print "1. Ocupar plaça concreta"
	print "2. Ocupar primera plaça buida"
	print "3. Sortir del parquing"
	print "4. Consultar estat"
	print "5. Llistar places buides"
	print "6. Comprova vehicle"

def intMat(matricula,posicio=-1):
	if posicio==-1:
		for i in range(1001):
			f.seek(i*8)
			if f.read(1) == 'X':
				f.seek(i*8)
				f.write(matricula)
				return True
	else:
		f.seek(posicio*8)
		if f.read(1) == 'X':
			f.seek(posicio*8)
			f.write(matricula)
			return True
		else:
			return False

def delMat(matricula):
	for i in range(1001):
		f.seek(i*8)
		if f.read(7) == matricula:
			f.seek(i*8)
			f.write('XXXXXXX')
			return True
	return False

def estatPl(posicio):
	f.seek(posicio*8)
	if f.read(1) == 'X':
		return False

	else:
		return True


def llistaBuides():
	a=[]
	for i in range(1001):
		if not estatPl(i):
			a.append(i)
	return a

def comprovaVehicle(matricula):
	for i in range(1001):
		f.seek(i*8)
		if f.read(7) == matricula:
			return i
	return -1


			

t=raw_input('Vols inicialitzar? [s/n]')
if t=='s':
	init()

f=open('places.dat','r+')

while(True):
	optionsProg()
	a=raw_input('Introdueix opcio: ')
	if a=='1':
		print "Quina plaça vols?"
		try:
			selparquing=input()
		except:
			print "No es un integer!"
		else:
			options=range(0,1001)
			if selparquing in options:
				matricula=raw_input('Fica la matricula: ')
				if len(matricula) == 7:
					if intMat(matricula,selparquing):
						print "Matricula afegida correctament"
					else:
						print "No s'ha pogut afegit la matricula"
	elif a=='2':
		matricula=raw_input('Fica la matricula: ')
		if len(matricula) == 7:
			if intMat(matricula):
				print "Matricula afegida correctament"
			else:
				print "No s'ha pogut afegit la matricula"

	elif a=='3':
		matricula=raw_input('Introdueix matricula: ')
		if len(matricula) == 7:
			if delMat(matricula):
				print "Matricula eliminada correctament"
			else:
				print "No s'ha pogut eliminar la matricula"

	elif a=='4':
		try:
			selparquing=input("Numero de plaça: ")
		except:
			print "No es un integer!"
		else:
			options=range(0,1001)
			if selparquing in options:
				if estatPl(selparquing):
					print "Està ocupat"
				else:
					print "Està buit"

	elif a=='5':
		if len(llistaBuides()) == 0:
			print "No hi ha llocs buits"
		else:
			print 'Llista de llocs buits:\n'+str(llistaBuides())

	elif a=='6':
		matricula=raw_input('Fica la matricula: ')
		if len(matricula) == 7:
			posicio=comprovaVehicle(matricula)
			if posicio != -1:
				print "El vehicle està en la posició "+str(posicio)
			else:
				print "El vehicle no està al parquing"

f.close()