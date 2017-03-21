#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import string
import sys

def init(nameinfo):
	f=open(nameinfo,'w+')
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
			return -1
	except: #No s'ha pogut convertir a int
		return -1

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
		return mat.upper()

def comprovaMatricula(matricula):  	#(comprova que la matricula sigui correcte i retorna matricula) # 0000XXX
	if (( len(matricula) == 7 )):
		num = matricula[0:4]
		lletr = matricula[5:7]
		#comprova num i lletr
		if (num.isdigit() and lletr.isalpha()):
			return True
		else:
			print "Mal format de matricula. Ex: 1234QWE"
			return False
	else:
		print "La matrícula entrada no es vàlida!"
		return False

def comprovaVehicle(matricula):
	for i in range(1001):
		f.seek(i*8)
		if f.read(7) == matricula:
			return i
	return -1

def retMatr(pos): #retorna la plaça que ocupa matr
	global f
	f.seek(pos*8)
	return f.read(7)

def optionsProg():
	print "1. Ocupar plaça concreta"
	print "2. Ocupar primera plaça buida"
	print "3. Sortir del pàrquing"
	print "4. Consultar estat de plaça"
	print "5. Llistar places buides"
	print "6. Comprova vehicle"
	print "7. Mostra tots els cotxes per pantalla"
	print "8. Sortir"

def main():
	while True:
		optionsProg()
		opt=raw_input('Introdueix opcio: ')
		if opt=='1':
			print "Ocupar plaça concreta"
			pl=demanaPl()
			if pl == -1:
				print "Plaça incorrecta"
			else:
				if not estatPl(pl):
					mat=demanaMat()
					if not mat or comprovaVehicle(mat) != -1:
						pass
					else:
						if intMat(mat,pl):
							print "Matrícula afegida correctament"
						else:
							print "No s'ha pogut afegir la matrícula"
				else:
					print "Plaça ocupada per el vehicle "+retMatr(pl)

		elif opt=='2':
			mat=demanaMat()
			if not mat or comprovaVehicle(mat) != -1:
				print "Matrícula incorrecta o ja existeix"
			else:
				if intMat(mat):
					print "Matrícula afegida correctament"
				else:
					if len(llistaBuides()) == 0:
						print "No hi ha llocs buits"
					else:
						print "No s'ha pogut afegit la matrícula"

		elif opt=='3':
			mat=demanaMat()
			if not mat:
				pass
			else:
				if delMat(mat):
					print "Matrícula eliminada correctament"
				else:
					print "No s'ha pogut trobar la matrícula!"

		elif opt=='4':
			pl=demanaPl()
			if pl == -1:
				print "Plaça incorrecta!"
			else:
				if estatPl(pl):
					print "La plaça "+str(pl)+" està ocupada per el cotxe "+str(retMatr(pl))
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
				pass
			else:
				posicio=comprovaVehicle(mat)
				if posicio != -1:
					print "El vehicle està en la posició "+str(posicio)
				else:
					print "El vehicle no està al parquing"

		elif opt=='7':
			print "\nLlistat de cotxes\n---------------"
			for i in range(1001):
				f.seek(i*8)
				mat = f.read(7)
				if mat[0] != "X":
					print "\t" + str(i) + "\t" + mat

			print "---------------"

		elif opt=='8':
			break
		raw_input()
	f.close()

saveInfoname='places.dat'
#Inicialització principal
if not os.path.isfile(saveInfoname):
	init(saveInfoname)

f=open(saveInfoname,'r+')

try:
	main()
except KeyboardInterrupt:
	print "\nTancant programa..."
	f.close()
	sys.exit(1)
