#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import string
import sys

def init():
	f=open('places.dat','w+')
	for i in range(0,1001):
		f.write('XXXXXXX')
		if i != 1000:
			f.write(' ')
	f.close()

def demanaPl():
	try:
		pl=input('Introdueix la plaça [0-1000]: ')
		if pl in range(0,1001):
			return pl
		else:
			return False
	except: #No s'ha pogut convertir a int
		return False

def intMat(matricula,posicio=-1):
	global f
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
	global f
	for i in range(1001):
		f.seek(i*8)
		if f.read(7) == matricula:
			f.seek(i*8)
			f.write('XXXXXXX')
			return True
	return False

def estatPl(posicio):
	global f
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

def demanaMat():
	mat=raw_input('Introdueix la matrícula: ')
	if not comprovaMatricula(mat):
		return False
	else:
		return mat

def comprovaMatricula(matricula):
	isCorrect=True
	for numb,character in enumerate(matricula):
		if numb < 4:
			if character not in string.digits:
				isCorrect=False
				break
		elif numb > 3 and numb < 7:
			if character not in string.letters:
				isCorrect=False
				break
		else:
			isCorrect=False
			break
	return isCorrect


def comprovaVehicle(matricula):
	for i in range(1001):
		f.seek(i*8)
		if f.read(7) == matricula:
			return i
	return -1

def optionsProg():
	print "1. Ocupar plaça concreta"
	print "2. Ocupar primera plaça buida"
	print "3. Sortir del pàrquing"
	print "4. Consultar estat de plaça"
	print "5. Llistar places buides"
	print "6. Comprova vehicle"
	print "7. Sortir"

def main():
	while True:
		optionsProg()
		opt=raw_input('Introdueix opcio: ')
		if opt=='1':
			print "Ocupar plaça concreta"
			pl=demanaPl()
			if not pl:
				print "Plaça incorrecta!"
			else:
				mat=demanaMat()
				if not mat or comprovaVehicle(mat) != -1:
					print "Matrícula incorrecta o ja està afegida!"
				else:
					if intMat(mat,pl):
						print "Matrícula afegida correctament"
					else:
						print "No s'ha pogut afegir la matrícula"

		elif opt=='2':
			mat=demanaMat()
			if not mat or comprovaVehicle(mat) != -1:
				print "Matrícula incorrecta o ja està afegida!"
			else:
				if intMat(mat):
					print "Matrícula afegida correctament"
				else:
					print "No s'ha pogut afegit la matrícula"

		elif opt=='3':
			mat=demanaMat()
			if not mat:
				print "Matrícula incorrecta!"
			else:
				if delMat(mat):
					print "Matrícula eliminada correctament"
				else:
					print "No s'ha pogut trobar la matrícula!"

		elif opt=='4':
			pl=demanaPl()
			if not pl:
				print "Plaça incorrecta!"
			else:
				if estatPl(pl):
					print "La plaça "+str(pl)+" està ocupada!"
				else:
					print "La plaça "+str(pl)+" està buida!"

		elif opt=='5':
			if len(llistaBuides()) == 0:
				print "No hi ha llocs buits"
			else:
				print 'Llista de llocs buits:\n'+str(llistaBuides())

		elif opt=='6':
			mat=demanaMat()
			if not mat:
				print "Matrícula incorrecta"
			else:
				posicio=comprovaVehicle(mat)
				if posicio != -1:
					print "El vehicle està en la posició "+str(posicio)
				else:
					print "El vehicle no està al parquing"

		elif opt=='7':
			break
		raw_input()
	f.close()

#Inicialització principal
if not os.path.isfile('places.dat'):
	init()

f=open('places.dat','r+')

try:
	main()
except KeyboardInterrupt:
	print "\nTancant programa..."
	f.close()
	sys.exit(1)

