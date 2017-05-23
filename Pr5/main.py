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
		self.list_toplevel = {}
		self.cursor = cursor
		self.db=db
		self.child_toplevel = None
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
		text_nom.grid(row=0,column=0)
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

		button_mostra_historic = Button(nou_registre,text="Mostra historic",fg="Blue",command=self.mostra_historic)
		button_mostra_historic.grid(row=4,column=0,sticky=W)

		mostrar_contactes = Button(self.frame,text="Mostrar contactes",fg="Blue",command=self.insert_contacts_treeview)
		mostrar_contactes.grid(sticky=W,row=3)

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
		elimina_seleccionat = Button(self.frame,text="Eliminar seleccionat",command=self.elimina_contacte,fg="Blue")
		elimina_seleccionat.grid(row=5,column=0,sticky=W)

		self.modificar_seleccionat = Button(self.frame,text="Modificar seleccionat",fg="Blue",command=self.modifica_contacte)
		self.modificar_seleccionat.grid(row=5,column=1,sticky=W)
		sortir = Button(self.frame,text="Sortir",fg="Blue",command=self.frame.quit)
		sortir.grid(row=5,column=2,sticky=E)

	def mostra_historic(self):
		popup=Toplevel()
		agenda_historic=Treeview(popup,columns=["nom","tel","email","path","accio","data"],show="headings")
		agenda_historic.heading("nom", text="Nom")
		agenda_historic.heading("tel",text="Telefon")
		agenda_historic.heading("email",text="Email")
		agenda_historic.heading("path",text="Path")
		agenda_historic.heading("accio",text="Acció")
		agenda_historic.heading("data",text="Data")
		agenda_historic.column("nom",minwidth=0,width=150,stretch=True,anchor="c")
		agenda_historic.column("tel",minwidth=0,width=100,stretch=True,anchor="c")
		agenda_historic.column("email",minwidth=0,width=150,stretch=True,anchor="c")
		agenda_historic.column("path",minwidth=0,width=200,stretch=True,anchor="c")
		agenda_historic.column("accio",minwidth=0,width=100,stretch=True,anchor="c")
		agenda_historic.column("data",minwidth=0,width=150,stretch=True,anchor="c")
		agenda_historic.grid(row=0,column=0,padx=5,pady=5)
		self.cursor.execute("select * from HISTORIC ORDER BY data DESC;")
		dades=self.cursor.fetchall()
		for data_usuari in dades:
			agenda_historic.insert('', 'end',values=data_usuari)

	def insert_contacts_treeview(self):
		self.cursor.execute("select * from CONTACTES order by nom ASC;")
		self.agenda_contactes.delete(*self.agenda_contactes.get_children())
		for i in self.cursor.fetchall():
			self.agenda_contactes.insert('', 'end',values=i[:2])

	def show_image(self,imatge_label,path_imatge=''):
		file_per_default = 'avatar.jpeg'
		if path_imatge=='':
			
			image=Image.open(file_per_default)
		else:
			if os.path.exists(path_imatge):
				try:
					image = Image.open(path_imatge)
				except:
					print "Error al mostrar imatge!"
					return False
			else:
				image=Image.open(file_per_default)
	
		image = image.resize((120, 120), Image.ANTIALIAS)
		photo = ImageTk.PhotoImage(image)
		imatge_label.configure(image = photo)
		imatge_label.image = photo
		return True

	def edit_image(self,imatge_label,path_imatge,nom,telefon):
		if os.path.isfile(path_imatge):
			try:
				image = Image.open(path_imatge)
			except:
				self.missatge_error_confirmacio.set("Imatge incorrecte!")

			else:
				try:
					self.cursor.execute("UPDATE CONTACTES SET foto=:pathfoto where nom=:nom and telf=:telf",{'pathfoto':path_imatge,'nom':nom,'telf':str(telefon)})
					self.db.commit()
				except:
					self.missatge_error_confirmacio.set("Error actualitzant la imatge!")
					return False
	
		self.show_image(imatge_label,path_imatge)

	def demana_imatge(self,imatge_label,nom,telefon):
		t=tkFileDialog.askopenfilename(title = "Selecciona foto",filetypes = (("jpg files","*.jpg"),("jpeg files","*.jpeg"),("all files","*.*")))
		if t:
			self.edit_image(imatge_label,t,nom,telefon)

	def modificar_contacte(self,entries_fixed,entries_variable,treeview_seleccionat):
		#print dades_usuari
		nom_fixed = entries_fixed[0]
		telefon_fixed = entries_fixed[1]
		email_fixed = entries_fixed[2]

		telefon_variable=entries_variable[0]
		email_variable=entries_variable[1]

		valor_text_telefon_antic = entries_fixed[3]
		valor_text_email_antic = entries_fixed[4]

		changed_email = False
		changed_tel = False
		if email_variable.get() != '':
			try:
				self.check_email(email_variable.get())
			except:
				self.missatge_error_confirmacio.set("El mail no és correcte!")
			else:
				self.cursor.execute("UPDATE CONTACTES SET email=:email where nom=:nom and telf=:telf",{'email':email_variable.get(),'nom':nom_fixed.get(),'telf':str(telefon_fixed.get())})
				valor_text_email_antic.set(email_variable.get())
				changed_email = True

		if telefon_variable.get()!='':
			try:
				assert int(telefon_variable.get()) >= 600000000
			except:
				self.missatge_error_confirmacio.set("Error en el telefon!")
			else:
				try:
					self.cursor.execute("UPDATE CONTACTES SET telf=:nou_telf where nom=:nom and telf=:telf",{'nou_telf':telefon_variable.get(),'nom':nom_fixed.get(),'telf':str(telefon_fixed.get())})
				except sqlite3.IntegrityError:
					self.missatge_error_confirmacio.set("El telèfon ja està registrat!")
				else:
					changed_tel=True
					self.agenda_contactes.item(treeview_seleccionat,values=(nom_fixed.get(),telefon_variable.get()))
					valor_text_telefon_antic.set(telefon_variable.get())
					
		self.db.commit()
		if changed_email & changed_tel:
			self.missatge_error_confirmacio.set("Dades modificades correctament!")
		elif changed_email:
			self.missatge_error_confirmacio.set("Email modificat correctament!")
		elif changed_tel:
			self.missatge_error_confirmacio.set("Telefon modificat correctament!")


			
		
	def modifica_contacte(self):
		if self.child_toplevel is not None:
			self.child_toplevel.destroy()

		element_a_modificar = self.agenda_contactes.focus()
		valor_usuari = self.agenda_contactes.item(element_a_modificar)['values']
		self.cursor.execute("select * from CONTACTES where nom=? and telf=?;",tuple(valor_usuari))
		dades=self.cursor.fetchone()
		t = Toplevel()
		self.child_toplevel=t
	
		label_imatge = Label(t)
		label_imatge.pack(side="left", fill="both", expand=True)
		self.show_image(label_imatge,dades[3])
		frame_info = Frame(t)
		frame_info.pack(side="right",fill="both",expand=False)
		label_nom = Label(frame_info,text="Nom: ")
		label_nom.grid(row=0,column=0)
		entry_nom = Entry(frame_info,textvariable=StringVar(frame_info,value=dades[0]),width=20,state='disabled')
		entry_nom.grid(row=0,column=1)
		label_telefon = Label(frame_info,text="Telefon antic: ")
		label_telefon.grid(row=1,column=0)
		text_telefon = StringVar(frame_info,value=dades[1])
		entry_telefon = Entry(frame_info,textvariable=text_telefon,width=20,state='disabled')
		entry_telefon.grid(row=1,column=1)

		label_telefon_nou = Label(frame_info,text="Telefon nou: ")
		label_telefon_nou.grid(row=2,column=0)
		entry_telefon_nou = Entry(frame_info,width=20)
		entry_telefon_nou.grid(row=2,column=1)

		label_email = Label(frame_info,text="Email: ")
		label_email.grid(row=3,column=0)
		text_email = StringVar(frame_info, value=dades[2]) #-----
		entry_email = Entry(frame_info, width=20, textvariable=text_email,state='disabled')
		entry_email.grid(row=3,column=1)
		label_email_nou = Label(frame_info,text="Email nou:")
		label_email_nou.grid(row=4,column=0)
		entry_email_nou = Entry(frame_info,width=20)
		entry_email_nou.grid(row=4,column=1)

		selecciona_imatge = Button(frame_info,text="Edita foto",command=lambda: self.demana_imatge(label_imatge,dades[0],text_telefon.get()))
		selecciona_imatge.grid(row=5)
		button_modifica_contacte = Button(frame_info,text="Modificar contacte",fg="Blue",command=lambda: self.modificar_contacte([entry_nom,entry_telefon,entry_email,text_telefon,text_email],[entry_telefon_nou,entry_email_nou],element_a_modificar))
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
			if self.child_toplevel is not None:
				self.child_toplevel.destroy()
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
				self.cursor.execute("""INSERT INTO CONTACTES values (?,?,?,'');""",(Nom.title(),Telef,self.entry_email.get()))
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