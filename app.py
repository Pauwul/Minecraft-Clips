# pseudo code for how the python part will work

# imports
# import clips

# import wxpython
# import pandas as pd
from tkinter import *
from tkinter import ttk
root = Tk()
frm = ttk.Frame(root, padding=10)
frm.grid()
ttk.Label(frm, text="Hello World!").grid(column=0, row=0)
ttk.Button(frm, text="Quit", command=root.destroy).grid(column=1, row=0)
root.mainloop()

import random
# Generate the config txt for every tile on the gui and resource

# | 0 | 0 | 0 |
# | 0 | x | 0 |
# | 0 | 0 | 0 |

def generate_file(file_path, rows, cols, probability):
    with open(file_path, 'w') as file:
        for _ in range(rows):
            row = [random.randint(0, 1) if random.random() < probability else 0 for _ in range(cols)]
            file.write(' '.join(map(str, row)) + '\n')


def generateResourceMap(file_path, rows, cols, *resources):
    resourceList = [ [column for column in range(4)] for row in range(4) ]
    for i in range(0, 10):
        for j in range(0,10):
            resourceList.append(0)
            if( resourceList[i-1][j-1] == 0 
               and resourceList[i-1][j] == 0 
               and resourceList[i-1][j+1] == 0 
               and resourceList[i+1][j] == 0 
               and resourceList[i+1][j+1] == 0 
                ):
                resourceList[i][j] = 1
    print(resourceList)

def generateMap():
    

# generateResourceMap()

# UI Setup, call external functions to edit the GUI





# import the config

