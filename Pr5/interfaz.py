from Tkinter import Tk, Frame, BOTH
from ttk import Frame, Button, Style
from ttk import Entry


class Example(Frame):  
    def __init__(self, parent):
        Frame.__init__(self, parent, background="white")   
         
        self.parent = parent
        
        self.initUI()
        
    
    def initUI(self):
      
      	#title
        	self.parent.title("Simple")
        	self.pack(fill=BOTH, expand=1)
        	Style().configure("TFrame", background="#333")

        #image
			bard = Image.open("bardejov.jpg")
        	bardejov = ImageTk.PhotoImage(bard)
        	label1 = Label(self, image=bardejov)
        	label1.image = bardejov
        	label1.place(x=20, y=20)

        #Button
        	frame = Frame(self, relief=RAISED, borderwidth=1)
        	frame.pack(fill=BOTH, expand=True)
        
        	self.pack(fill=BOTH, expand=True)
        
        	closeButton = Button(self, text="Close")
        	closeButton.pack(side=RIGHT, padx=5, pady=5)
        	okButton = Button(self, text="OK")
        	okButton.pack(side=RIGHT)

        #Layout (capas)
        	frame1 = Frame(self)
        	frame1.pack(fill=X)
        
        	lbl1 = Label(frame1, text="Title", width=6)
        	lbl1.pack(side=LEFT, padx=5, pady=5)           
       	
        	entry1 = Entry(frame1)
        	entry1.pack(fill=X, padx=5, expand=True)
        
        	frame2 = Frame(self)
        	frame2.pack(fill=X)
        
        	lbl2 = Label(frame2, text="Author", width=6)
        	lbl2.pack(side=LEFT, padx=5, pady=5)        

        	entry2 = Entry(frame2)
        	entry2.pack(fill=X, padx=5, expand=True)

        #Quit button
        	self.parent.title("Quit button")
        	self.style = Style()
        	self.style.theme_use("default")
        	self.pack(fill=BOTH, expand=1)
        	quitButton = Button(self, text="Quit",
            command=self.quit)
        	quitButton.place(x=50, y=50)
	
		#Calculator example
			self.columnconfigure(0, pad=3)
	        self.columnconfigure(1, pad=3)
	        self.columnconfigure(2, pad=3)
	        self.columnconfigure(3, pad=3)
	        
	        self.rowconfigure(0, pad=3)
	        self.rowconfigure(1, pad=3)
	        self.rowconfigure(2, pad=3)
	        self.rowconfigure(3, pad=3)
	        self.rowconfigure(4, pad=3)
	        
	        entry = Entry(self)
	        entry.grid(row=0, columnspan=4, sticky=W+E)
	        cls = Button(self, text="Cls")
	        cls.grid(row=1, column=0)
	        bck = Button(self, text="Back")
	        bck.grid(row=1, column=1)
	        lbl = Button(self)
	        lbl.grid(row=1, column=2)    
	        clo = Button(self, text="Close")
	        clo.grid(row=1, column=3)        
	        sev = Button(self, text="7")
	        sev.grid(row=2, column=0)        
	        eig = Button(self, text="8")
	        eig.grid(row=2, column=1)         
	        nin = Button(self, text="9")
	        nin.grid(row=2, column=2) 
	        div = Button(self, text="/")
	        div.grid(row=2, column=3) 
	        
	        fou = Button(self, text="4")
	        fou.grid(row=3, column=0)        
	        fiv = Button(self, text="5")
	        fiv.grid(row=3, column=1)         
	        six = Button(self, text="6")
	        six.grid(row=3, column=2) 
	        mul = Button(self, text="*")
	        mul.grid(row=3, column=3)    
	        
	        one = Button(self, text="1")
	        one.grid(row=4, column=0)        
	        two = Button(self, text="2")
	        two.grid(row=4, column=1)         
	        thr = Button(self, text="3")
	        thr.grid(row=4, column=2) 
	        mns = Button(self, text="-")
	        mns.grid(row=4, column=3)         
	        
	        zer = Button(self, text="0")
	        zer.grid(row=5, column=0)        
	        dot = Button(self, text=".")
	        dot.grid(row=5, column=1)         
	        equ = Button(self, text="=")
	        equ.grid(row=5, column=2) 
	        pls = Button(self, text="+")
	        pls.grid(row=5, column=3)
	        
	        self.pack()
	


	def centerWindow(self):
      
        w = 290
        h = 150

        sw = self.parent.winfo_screenwidth()
        sh = self.parent.winfo_screenheight()
        
        x = (sw - w)/2
        y = (sh - h)/2
        self.parent.geometry('%dx%d+%d+%d' % (w, h, x, y))

	        

def main():
  
    root = Tk()
    ex = Example(root)
    root.mainloop()


if __name__ == '__main__':
    main()