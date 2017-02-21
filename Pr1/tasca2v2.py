#!/usr/bin/env python
# -*- coding: utf-8 -*-

def init(): #CREAR BBDD NOVA AMB TOT XXXXXXX
	f=open('places.dat','w+')
	for i in range(0,1001):
		f.write('XXXXXXX')
		if i != 1000:
			f.write(' ')
	f.close()

def optionsProg(): #MENU
	print "---------------\nMENÚ PRINCIPAL\n---------------"
	print "1. Ocupar plaça concreta"
	print "2. Ocupar primera plaça buida"
	print "3. Sortir del parquing"
	print "4. Consultar estat de plaça"
	print "5. Llistar places buides"
	print "6. Comprova vehicle"
	print "7. Mostra per pantalla vehicles que hi ha dins del pàrquing"
	print "q. Surt i tanca BD"
	print "---------------"


def llistaBuides():  #retrona llista amb les places buides.
	a=[]
	for i in range(1001):
		if not estatPl(i):
			a.append(i)
	return a

def intMat(matricula,posicio=-1): #Entra matricula al parking, amb plaça o sense ella.
	if posicio==-1:
		if llistaBuides != []: #COMPROVA QUE EL PARKING NO ESTIGUI PLE
			for i in range(1001):
				f.seek(i*8)
				if f.read(1) == 'X': #No cal
					f.seek(i*8)
					f.write(matricula)
					return True
				else:
					return False
		else:
			print "PARKING PLE!"
			return False
	else:	#Insertant posicio de parking
		f.seek(posicio*8)
		if f.read(1) == 'X': #No cal, feta la comprovació abans (comprovació extra)
			f.seek(posicio*8)
			f.write(matricula)
			return True 	#Matricula insertada correctament
		else:
			return False

def estatPl(posicio): #retorna False si la plaça esta buida, True si hi ha algun cotxe.
	f.seek(posicio*8)
	if f.read(1) == 'X':
		return False

	else:
		return True


def matrInPark(matricula): # comrpova si una matricula és al parking
								# retorna True si el vehicle hi és al parking
	for i in range(1001):
		f.seek(i*8)
		if f.read(7) == matricula:
			return True
	return False


def checkMatr(matricula):  	#(comprova que la matricula sigui correcte i retorna matricula)
							# 0000XXX
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



def delMat(matricula): # elimina matricula del parking
	for i in range(1001):
		f.seek(i*8)
		if f.read(7) == matricula:
			f.seek(i*8)
			f.write('XXXXXXX')
			return True
	return False



def posi(matr): #retorna la plaça que ocupa matr
	for i in range(1001):
		f.seek(i*8)
		if f.read(7) == matricula:
			return i
	return -1 #Per error, mai hauria de entrar aqui


def retMatr(pos): #retorna la plaça que ocupa matr
	f.seek(pos*8)
	return f.read(7)

#COMENḈA EL PROGRAMA

t=raw_input('Vols inicialitzar? [s/n] ')
if t=='s':
	init()

f=open('places.dat','r+') #Obrim base de dades

flag = True #Flag que permet tencar el programa/base de dades correctament


while(flag):
	
	optionsProg()
	a=raw_input('Introdueix opcio: ')
	

	if a=='1': #OCUPAR PLAÇA CONCRETA (MATRICULA OK, PLAÇA ENTRADA BUIDA -> SINO MOSTRAR)
		try:
			selparquing=input("Quina plaça vols? ")
		except:
			print "No es un integer!"
		else:
			#options=range(0,1001)
			#if selparquing in options:
			if  ( (0 <= selparquing) and (selparquing < 1001) ): #plaça <1001

				#Plaça buida?
				if (selparquing in llistaBuides()):

					#Introdueix matricula:
					matricula=raw_input('Introduexi matricula que vol entrar: ')
					
					#Comprova el format de la matricula (0000XXX)
					if checkMatr(matricula):

						#Comprovem si la matricula ja es al parking
						if not matrInPark(matricula):

							if intMat(matricula,selparquing):
								print "Matricula insertada correctament!"

							else:
								print "Intent de insertar matricula fallat."

						else:
							print "Vehicle ja hi és al parking. Plaça: " + posi(matricula) 

					else: 
						print "Error en el format de la matricula entrada. Ex: 1234ABC"

				else: #Plaça ocupada
					print "Plaça ocupada pel cotxe: " + retMatr(selparquing)

			else:
				print "Plaça no admesa"


	elif a=='2':
		#"2. Ocupar primera plaça buida"

		matricula=raw_input('Introduexi matricula que vol entrar: ')
					
		#Comprova el format de la matricula (0000XXX)
		if checkMatr(matricula):

			#Comprovem si la matricula ja es al parking
			if not matrInPark(matricula):

				if intMat(matricula):
					print "Matricula insertada correctament!"

				else:
					print "Intent de insertar matricula fallat."
			else:
				print "Vehicle ja hi és al parking. Plaça: " + posi(matricula) 
		else: 
			print "Error en el format de la matricula entrada. Ex: 1234ABC"


	elif a=='3':
		# print "3. Sortir del parquing"

		matricula=raw_input('Introduexi matricula que vol entrar: ')
					
		#Comprova el format de la matricula (0000XXX)
		if checkMatr(matricula):

			#Comprovem si la matricula ja es al parking
			if matrInPark(matricula):

				if delMat(matricula):
					print "Matricula eliminada correctament"
				else:
					print "No s'ha pogut eliminar la matricula"
			else:
				print "El vehicle no es troba al parking"
		else:
			print "Error en el format de la matricula entrada. Ex: 1234ABC"

	elif a=='4':
		#4. Consultar estat de plaça
		try:
			selparquing=input("Numero de plaça: ")
		except:
			print "No es un integer!"
		else:
			options=range(0,1001)
			if selparquing in options:
				if estatPl(selparquing):
					print "Està ocupada" + str( retMatr(selparquing) ) #------------FALTA MOSTRAR MATRICULA PER PANTALLA
				else:
					print "Està buida"

	elif a=='5':
		#5. Llistar places buides
		if len(llistaBuides()) == 0:
			print "No hi ha llocs buits"
		else:
			print 'Llista de llocs buits:\n'+str(llistaBuides())

	elif a=='6':
		#"6. Comprova vehicle"


		#Introdueix matricula:
		matricula=raw_input('Introduexi matricula que vol entrar: ')
					
		#Comprova el format de la matricula (0000XXX)
		if checkMatr(matricula):

			#Comprovem si la matricula ja es al parking
			if matrInPark(matricula):

				posicio=posi(matricula)
				if posicio != -1:
					print "El vehicle està a la plaça " + str(posicio)
				else: #no hauria de entrar mai
					print "El vehicle no està al parquing"
		
			else:
				print "No és al parking"
		else:
			print "Error en el format de la matricula."


	elif a=='7':
		print "\nLlistat de cotxes\n---------------"
		for i in range(1001):
			f.seek(i*8)
			mat = f.read(7)
			if mat[0] != "X":
				
				print "\t" + str(i) + "\t" + mat

		print "---------------"

	elif a == 'q':
		flag = False

	else:
		print "Opció incorrecta"

f.close()

print '---------------\nBye!\n---------------\nFet per: Pol i David\n'
