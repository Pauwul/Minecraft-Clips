import tkinter as tk

def generate_grid():
    try:
        rows = int(rows_entry.get())
        columns = int(columns_entry.get())
        
        if rows <= 0 or columns <= 0:
            result_label.config(text="Please enter positive numbers for rows and columns.", fg="red")
            return
        
        grid = [['_' for _ in range(columns)] for _ in range(rows)]
        result_label.config(text="Generated grid:", fg="black")
        display_grid(grid)
    except ValueError:
        result_label.config(text="Please enter valid integers for rows and columns.", fg="red")

def display_grid(grid):
    for widget in result_frame.winfo_children():
        widget.destroy()
    
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            label = tk.Label(result_frame, text=grid[i][j], width=4, height=2, relief="ridge")
            label.grid(row=i, column=j)

root = tk.Tk()
root.title("Grid Generator")

input_frame = tk.Frame(root)
input_frame.pack(pady=10)

rows_label = tk.Label(input_frame, text="Rows:")
rows_label.grid(row=0, column=0, padx=5)

rows_entry = tk.Entry(input_frame)
rows_entry.grid(row=0, column=1, padx=5)

columns_label = tk.Label(input_frame, text="Columns:")
columns_label.grid(row=0, column=2, padx=5)

columns_entry = tk.Entry(input_frame)
columns_entry.grid(row=0, column=3, padx=5)

generate_button = tk.Button(input_frame, text="Generate Grid", command=generate_grid)
generate_button.grid(row=1, columnspan=4, pady=5)

result_label = tk.Label(root, text="", fg="black")
result_label.pack()

result_frame = tk.Frame(root)
result_frame.pack()

root.mainloop()
