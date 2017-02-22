#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import string
import sys
import struct

def init(nameinfo):
    global formatStruct
    global sizeMat
    global sizeMarca
    global sizeCol
    f=open(nameinfo,'w+')
    for i in range(0,1001):
        f.write('X'*sizeMat+'0'*sizeMarca+'0'*sizeCol)
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

def intMat(matricula,carcotxe,posicio=-1):
    global f
    global formatStruct
    global emptyMat
    if posicio==-1:
        for i in range(1001):
            f.seek(i*(formatStruct.size+1))
            values=formatStruct.unpack(f.read(formatStruct.size))
            if values[0] == emptyMat:
                f.seek(i*(formatStruct.size+1))
                f.write(matricula+carcotxe[0]+carcotxe[1])
                return True

    else:
        f.seek(posicio*(formatStruct.size+1))
        values=formatStruct.unpack(f.read(formatStruct.size))
        if values[0] == emptyMat:
            f.seek(posicio*(formatStruct.size+1))
            f.write(matricula+carcotxe[0]+carcotxe[1])
            return True
        else:
            return False

def delMat(matricula):
    global f
    global formatStruct
    global sizeMat
    global sizeMarca
    global sizeCol
    for i in range(1001):
        f.seek(i*(formatStruct.size+1))
        if formatStruct.unpack(f.read(formatStruct.size))[0] == matricula:
            f.seek(i*(formatStruct.size+1))
            f.write('X'*sizeMat+'0'*sizeMarca+'0'*sizeCol)
            return True
    return False

def estatPl(posicio):
    global f
    global emptyMat
    f.seek(posicio*(formatStruct.size+1))
    if formatStruct.unpack(f.read(formatStruct.size))[0] == emptyMat:
        return False
    else:
        return True


def matrPl(posicio):
    global f
    global emptyMat
    f.seek(posicio*(formatStruct.size+1))
    tupl=formatStruct.unpack(f.read(formatStruct.size))

    if tupl[0] == emptyMat:
        return False
    else:
        return mostDetalls(tupl)



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

def demanaColMarca():
    global sizeMarca
    global sizeCol
    marccotxe=raw_input("Escriu la marca del cotxe: ")
    while len(marccotxe) < sizeMarca:
        marccotxe+='0'
    colcotxe=raw_input("Escriu el color del cotxe: ")
    while len(colcotxe) < sizeCol:
        colcotxe+='0'

    return [colcotxe.upper(), marccotxe.upper()] if (colcotxe[:colcotxe.find('0')][:sizeCol].isalpha() and len(colcotxe) <= sizeMarca) and (marccotxe[:marccotxe.find('0')][:sizeMarca].isalpha() and len(marccotxe) <= sizeMarca) else False

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
    """
    Retorna la posició, el color i la marca
    """
    global f
    for i in range(1001):
        f.seek(i*(formatStruct.size+1))
        values=formatStruct.unpack(f.read(formatStruct.size))
        if values[0] == matricula:
            return [i,values[1],values[2]]
    return -1



def mostDetalls(tupl):

    global a
    a = "Matricula " + tupl[0] + ", Color "

    if tupl[1].find('0') != -1:
        a += tupl[1][:tupl[1].find('0')]
    else:
        a += tupl[1]

    a += ", Marca " 

    if tupl[2].find('0') != -1:
        a += tupl[2][:tupl[2].find('0')]
    else:
        a += tupl[2]

    return a 


def optionsProg():
	print "1. Ocupar plaça concreta"
	print "2. Ocupar primera plaça buida"
	print "3. Sortir del pàrquing"
	print "4. Consultar estat de plaça"
	print "5. Llistar places buides"
	print "6. Comprova vehicle"
	print "7. Llistar totes les places"
	print "q. Sortir"

def main():
	while True:
		optionsProg()
		opt=raw_input('Introdueix opcio: ')
		if opt=='1':
			print "Ocupar plaça concreta"
			pl=demanaPl()
			if not pl:
				print "Plaça incorrecta"
			else:
				mat=demanaMat()
				if not mat or comprovaVehicle(mat) != -1:
					print "Matrícula incorrecta o ja està afegida!"
				else:
					carcotxe=demanaColMarca()
					if not carcotxe:
						print "Paràmetres incorrectes!"
					else:
						if intMat(mat,carcotxe,pl):
							print "Cotxe afegit correctament"
						else:
							print "No s'ha pogut afegir el cotxe"
		elif opt=='2':
			mat=demanaMat()
			if not mat or comprovaVehicle(mat) != -1:
				print "Matrícula incorrecta o ja està afegida!"
			else:
				carcotxe=demanaColMarca()
				if not carcotxe:
					print "Paràmetres incorrectes!"
				else:
					if intMat(mat,carcotxe):
						print "Cotxe afegit correctament"
					else:
						print "No s'ha pogut afegir el cotxe"

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
			if pl==-1:
				print "Plaça incorrecta!"
			else:
				if estatPl(pl):
					print "La plaça "+str(pl)+" està ocupada pel cotxe: "+str(matrPl(pl))
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
				infovehicle=comprovaVehicle(mat)
				if infovehicle != -1:
					print "Informació del vehicle "+str(infovehicle)
				else:
					print "El vehicle no està al parquing"
		elif opt=='7':
			global emptyMat
			print "\nLlistat de cotxes\n---------------"
			for i in range(1001):
				f.seek(i*(formatStruct.size+1))
				tupl = formatStruct.unpack(f.read(formatStruct.size))
				if tupl[0] != emptyMat:
					print "\t" + str(i) + "\t" + mostDetalls(tupl)

			print "---------------"

		elif opt=='q':
			break
		raw_input()
	f.close()

saveInfoname='places2.dat'
emptyMat='XXXXXXX'
sizeMat=7
sizeMarca=10
sizeCol=7
formatStruct=struct.Struct(str(sizeMat)+'s '+str(sizeCol)+'s '+str(sizeMarca)+'s') #Definim un format on -> Matricula -> 7 caràcters | Marca -> 10 caràcters | Color -> 7 caràcters

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
