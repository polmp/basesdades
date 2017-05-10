#!/usr/bin/env python
# -*- coding: utf-8 -*-

from Tkinter import *
from ttk import Treeview
from PIL import Image, ImageTk
import Image

class App(object):
	def __init__(self,root):
		self.frame = Frame(root)
		self.frame.pack()
		image = Image.open("photo.jpg")
		image = image.resize((250, 250), Image.ANTIALIAS)
		photo = ImageTk.PhotoImage(image)
		label = Label(self.frame,image=photo)
		label.grid(row=0,column=0,sticky=W)
		label.image = photo # keep a reference!
		nou_registre = LabelFrame(self.frame, text="Nou registre", fg="Blue",padx=5, pady=5)
		nou_registre.grid(row=0,column=1,padx=15,sticky=W)

		text_nom = Label(nou_registre,text="Nom:",fg="Blue")
		text_nom.grid(row=0,column=0,sticky=W)
		entry_nom = Entry(nou_registre)
		entry_nom.grid(row=0,column=1,sticky=W)

		text_telefon = Label(nou_registre,text="Telèfon: ",fg="Blue")
		text_telefon.grid(row=1,column=0)
		entry_telefon=Entry(nou_registre)
		entry_telefon.grid(row=1,column=1)

		button_afegir_contacte = Button(nou_registre,text="Afegir contacte",fg="Blue")
		button_afegir_contacte.grid(row=2,column=1,sticky=E)

		mostar_contactes = Button(self.frame,text="Mostrar contactes",fg="Blue")
		mostar_contactes.grid(sticky=W,row=3)

		missatge_error_confirmacio = Label(self.frame,text="HOLA",fg="Red")
		missatge_error_confirmacio.grid(sticky=W,row=3,column=1)

		agenda_contactes=Treeview(self.frame,columns=["nom","tel"],show="headings")
		
		agenda_contactes.heading("nom", text="Nom")
		agenda_contactes.heading("tel",text="Telefon")
		agenda_contactes.column("#0",minwidth=0,width=200,stretch=NO,anchor=E)
		agenda_contactes.column("tel",minwidth=0,width=200,stretch=NO)
		agenda_contactes.grid(row=4,column=0,padx=0,columnspan=2)
		
		#stretch NO not working
		
		agenda_contactes.insert('', 'end',text='Hola',values=['Hola','Adeu'])

		elimina_seleccionat = Button(self.frame,text="Eliminar seleccionat",fg="Blue")
		elimina_seleccionat.grid(row=5,column=0,sticky=W)

		modificar_seleccionat = Button(self.frame,text="Modificar seleccionat",fg="Blue")
		modificar_seleccionat.grid(row=5,column=1,sticky=W)
		sortir = Button(self.frame,text="Sortir",fg="Blue",command=self.frame.quit)
		sortir.grid(row=5,column=2,sticky=E)
		
	


root = Tk()
root.wm_title("Dipse Gestor de Contactes")
app=App(root)
root.mainloop()
root.destroy()