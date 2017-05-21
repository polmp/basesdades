#!/usr/bin/env python
# -*- coding: utf-8 -*-

from Tkinter import Frame,Tk,Label,W,LabelFrame,Entry,Button,E,StringVar,NO,Toplevel,N,END,S
from ttk import Treeview

import tkFileDialog
from PIL import Image, ImageTk
import Image
import os
import sqlite3
import re

class App(object):
	def __init__(self,root,cursor,db):
		self.frame = Frame(root)
		self.cursor = cursor
		self.db=db
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
		self.entry_nom = Entry(nou_registre)
		self.entry_nom.grid(row=0,column=1,sticky=W)

		text_telefon = Label(nou_registre,text="Telèfon: ",fg="Blue")
		text_telefon.grid(row=1,column=0)
		self.entry_telefon=Entry(nou_registre)
		self.entry_telefon.grid(row=1,column=1)

		text_email = Label(nou_registre,text="Email: ",fg="Blue")
		text_email.grid(row=2,column=0)
		self.entry_email=Entry(nou_registre)
		self.entry_email.grid(row=2,column=1)

		button_afegir_contacte = Button(nou_registre,text="Afegir contacte",fg="Blue",command=self.afegeix_contacte)
		button_afegir_contacte.grid(row=3,column=1,sticky=E)

		mostar_contactes = Button(self.frame,text="Mostrar contactes",fg="Blue")
		mostar_contactes.grid(sticky=W,row=3)

		self.missatge_error_confirmacio = StringVar()

		self.label_error_confirmacio = Label(self.frame,textvariable=self.missatge_error_confirmacio,fg="Red")
		self.label_error_confirmacio.grid(sticky=W,row=3,column=1)

		self.agenda_contactes=Treeview(self.frame,columns=["nom","tel"],show="headings")
		self.agenda_contactes.heading("nom", text="Nom")
		self.agenda_contactes.heading("tel",text="Telefon")
		self.agenda_contactes.column("nom",minwidth=0,width=200,stretch=NO,anchor="c")
		self.agenda_contactes.column("tel",minwidth=0,width=200,stretch=NO,anchor="c")
		self.agenda_contactes.grid(row=4,column=0,padx=0,columnspan=2)

		self.insert_contacts_treeview()
		#self.agenda_contactes.bind('<ButtonRelease-1>', self.treeview_select)
		
		
		
		elimina_seleccionat = Button(self.frame,text="Eliminar seleccionat",command=self.elimina_contacte,fg="Blue")
		elimina_seleccionat.grid(row=5,column=0,sticky=W)

		self.modificar_seleccionat = Button(self.frame,text="Modificar seleccionat",fg="Blue",command=self.modifica_contacte)
		self.modificar_seleccionat.grid(row=5,column=1,sticky=W)
		sortir = Button(self.frame,text="Sortir",fg="Blue",command=self.frame.quit)
		sortir.grid(row=5,column=2,sticky=E)

	def insert_contacts_treeview(self):
		self.cursor.execute("select * from CONTACTES order by nom;")
		self.db.commit()
		self.agenda_contactes.delete(*self.agenda_contactes.get_children())
		for i in self.cursor.fetchall():
			self.agenda_contactes.insert('', 'end',values=i[:2])

	def edita_imatge(self,imatge_label):
		t=tkFileDialog.askopenfilename(title = "Select file",filetypes = (("jpg files","*.jpg"),("jpeg files","*.jpeg"),("all files","*.*")))
		if (t != '') & os.path.isfile(t):
			image = Image.open(t)
			image = image.resize((120, 120), Image.ANTIALIAS)
			photo = ImageTk.PhotoImage(image)
			imatge_label.configure(image = photo)
			imatge_label.image = photo
		
	def modifica_contacte(self):
		t = Toplevel()
		image = Image.open("avatar.jpeg")
		image = image.resize((120, 120), Image.ANTIALIAS)
		photo = ImageTk.PhotoImage(image)
		label_imatge = Label(t,image=photo)
		label_imatge.pack(side="left", fill="both", expand=True)
		#label_imatge.grid(row=0,column=0,padx=10,sticky=W)
		label_imatge.image = photo # keep a reference!
		frame_info = Frame(t)
		frame_info.pack(side="right",fill="both",expand=False)
		label_nom = Label(frame_info,text="Nom: ")
		label_nom.grid(row=0,column=0)
		entry_nom = Entry(frame_info,textvariable=StringVar(frame_info,value='NOMM'),width=20,state='disabled')
		entry_nom.grid(row=0,column=1)
		label_telefon = Label(frame_info,text="Telefon antic: ")
		label_telefon.grid(row=1,column=0)
		entry_telefon = Entry(frame_info,textvariable=StringVar(frame_info,value='6485848'),width=20,state='disabled')
		entry_telefon.grid(row=1,column=1)

		label_telefon_nou = Label(frame_info,text="Telefon nou: ")
		label_telefon_nou.grid(row=2,column=0)
		entry_telefon_nou = Entry(frame_info,width=20)
		entry_telefon_nou.grid(row=2,column=1)

		label_email = Label(frame_info,text="Email: ")
		label_email.grid(row=3,column=0)
		text_email = StringVar(frame_info, value='email_antic') #-----
		entry_email = Entry(frame_info, width=20, textvariable=text_email,state='disabled')
		entry_email.grid(row=3,column=1)
		label_email_nou = Label(frame_info,text="Email nou:")
		label_email_nou.grid(row=4,column=0)
		entry_email_nou = Entry(frame_info,width=20)
		entry_email_nou.grid(row=4,column=1)

		selecciona_imatge = Button(frame_info,text="Edita foto",command=lambda: self.edita_imatge(label_imatge))
		selecciona_imatge.grid(row=5)
		button_modifica_contacte = Button(frame_info,text="Modificar contacte",fg="Blue",command=self.modifica_contacte)
		button_modifica_contacte.grid(row=6,column=1,sticky=E)
		
		

	def check_email(self,email):
		if re.match("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",email):
			return True
		else:
			raise "Mail no vàlid!"
	def elimina_contacte(self):
		element_seleccionat = self.agenda_contactes.focus()
		if element_seleccionat != '':
			informacio_contacte = self.agenda_contactes.item(element_seleccionat)['values']
			self.cursor.execute("DELETE from CONTACTES where nom=? and telf=?",tuple(informacio_contacte))
			self.db.commit()
			self.agenda_contactes.delete(element_seleccionat)
			self.missatge_error_confirmacio.set("Borrat correctament")
			#print self.agenda_contactes.focus()
			#print self.agenda_contactes.selection()
		else:
			self.missatge_error_confirmacio.set("Selecciona un usuari!")
			print "Selecciona element"

	def afegeix_contacte(self):
		try:
			Nom = self.entry_nom.get()
			assert Nom != ''
			Telef = int(self.entry_telefon.get())
			assert Telef > 600000000
			Email = self.check_email(self.entry_email.get())

		except:
			self.missatge_error_confirmacio.set("Introdueix les dades correctament!")
		else:
			try:
				self.cursor.execute("""INSERT INTO CONTACTES values (?,?,?,'');""",(Nom,Telef,Email))
				self.db.commit()
			except sqlite3.IntegrityError:
				self.missatge_error_confirmacio.set("Contacte ja existent!")

			else:
				self.insert_contacts_treeview()
				self.missatge_error_confirmacio.set("Afegit contacte correctament")
			

if __name__=='__main__':
	if not os.path.isfile('agenda.bd'):
		db=sqlite3.connect('agenda.bd')
		cur=db.cursor()
		with open('telf.sql') as arxiu:
			info=arxiu.read()
			cur.executescript(info)
	else:
		db=sqlite3.connect('agenda.bd')
		cur=db.cursor()
	root = Tk()
	root.wm_title("Dipse Gestor de Contactes")
	app=App(root,cur,db)
	root.mainloop()
	try:
		root.destroy()
	except:
		pass