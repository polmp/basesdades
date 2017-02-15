#!/usr/bin/env python
# -*- coding: utf-8 -*-

def init():
	f=open('places.dat','w+')
	for i in range(0,1001):
		f.write('XXXXXXX')
		if i != 1000:
			f.write(' ')
	f.close()

def options():
	print "1. Ocupar plaça concreta"
	print "2. Ocupar primera plaça buida"
	print "3. Sortir del parquing"

init()
f=open('places.dat','r+')
options()
a=raw_input('Introdueix opcio')

if a=='1':
	print "Quina plaça vols?"
	try:
		selparquing=input()
	except:
		print "No es un integer!"
	else:
		options=range(0,1001)
		if selparquing in options:
			posicio=selparquing*8
			f.seek(posicio)
			print f.tell()
			if f.read(1) == 'X':
				print "La posicio "+str(selparquing)+" està buida"
				f.write('2222')

			else:
				print "Està ocupada"
