import time

import clips
from tkinter import Tk, Canvas, Label, Text, Entry, Button, PhotoImage
from PIL import Image, ImageTk


class GameGrid:
    def __init__(self, root, grid_size, env, fact_text):
        self.root = root
        self.root.resizable(False, False)
        self.grid_size = grid_size
        self.status_label = Label(self.root, text="", font=('Comic Sans MS', 16, 'bold'), bg="black", fg="white")
        self.status_label.grid(row=0, column=1)
        root.configure(bg='black')  # Set window background color to black

        # Constants for canvas size and cell dimensions
        self.canvas_size = 500
        self.cell_size = self.canvas_size / self.grid_size
        self.canvas = Canvas(self.root, width=self.canvas_size, bg="gray20", height=self.canvas_size)
        bg_image = Image.open("./background.png")
        bg_image = ImageTk.PhotoImage(bg_image)
        self.root.configure(bg="black")
        # self.canvas.create_image(0, 0, anchor="nw", fill="brown")
        self.canvas.grid(row=1, column=1)

        # Load and resize images
        self.images = {
            'player': self.resize_image('steve.png', scale_factor=1),
            'inamic': self.resize_image('skel.png', scale_factor=1),
            'lava': self.resize_image('lava.png', scale_factor=1),
            'intrare': self.resize_image('door.png', scale_factor=0.7),
            'diamant': self.resize_image('diamond.png', scale_factor=0.8),
            'iesire': self.resize_image('door.png', scale_factor=0.8)
        }

        self.env = env
        self.fact_text = fact_text

        self.start_button = Button(self.root, text="Start simulation", bg="gray20", command=self.set_start, fg="white")
        self.start_button.grid(row=2, column=0)

        self.start_flag = 0

        # Entry to write fact
        self.fact_entry = Entry(self.root, width=20, bg="gray20", fg="white")
        self.fact_entry.grid(row=2, column=1)

        # Button to submit fact
        self.submit_button = Button(self.root, text="Add Entity", bg="gray20", command=self.add_fact, fg="white")
        self.submit_button.place(x=540, y=540)

        # Button to close window
        self.close = Button(self.root, text="Close", bg="gray20", fg="white", command=self.close_window)
        self.close.place(x=640, y=540)


    def set_start(self):
        self.start_flag = 1
    
    
    def close_window(self):
        self.root.destroy()


    def add_fact(self):
        # Assert the fact into the CLIPS environment
        fact = self.fact_entry.get()
        self.env.assert_string(fact)
        self.fact_entry.delete(0, 'end')  # Clear the entry field after adding the fact
        update_fact_text(self.env, self.fact_text)

    def resize_image(self, image_path, scale_factor=1):
        original_image = Image.open(image_path)

        # Calculate the aspect ratio of the original image
        aspect_ratio = original_image.width / original_image.height

        # Set maximum width and height for the lava image
        max_width = int(self.cell_size * scale_factor)
        max_height = int(self.cell_size * scale_factor)

        # Calculate the target width and height based on the aspect ratio and maximum dimensions
        if original_image.width > original_image.height:
            target_width = min(original_image.width, max_width)
            target_height = int(target_width / aspect_ratio)
        else:
            target_height = min(original_image.height, max_height)
            target_width = int(target_height * aspect_ratio)

        # Resize the image to fit the maximum dimensions while maintaining aspect ratio
        resized_image = original_image.resize((target_width, target_height), Image.LANCZOS)

        return ImageTk.PhotoImage(resized_image)

    def update_entities(self, entities, level, message=""):
        self.canvas.delete("all")
        self.draw_entities(entities)
        self.draw_grid_lines()
        self.status_label.config(text=f"Level: {level} {message}")

    def draw_entities(self, entities):
        # Draw entities with images
        for entity in entities:
            x, y = entity['x'] - 1, self.grid_size - entity['y']  # Adjust coordinates for canvas drawing
            # Calculate the center coordinates of the cell
            cell_center_x = x * self.cell_size + self.cell_size / 2
            cell_center_y = y * self.cell_size + self.cell_size / 2
            # Calculate the top-left corner coordinates for drawing the image
            image_x = cell_center_x - self.images[entity['type']].width() / 2
            image_y = cell_center_y - self.images[entity['type']].height() / 2
            self.canvas.create_image(image_x, image_y, anchor='nw', image=self.images[entity['type']])

    def draw_grid_lines(self):
        # Draw grid lines
        for i in range(self.grid_size + 1):
            # Vertical lines
            self.canvas.create_line(i * self.cell_size, 0, i * self.cell_size, self.canvas_size, fill='white', width=2)
            # Horizontal lines
            self.canvas.create_line(0, i * self.cell_size, self.canvas_size, i * self.cell_size, fill='white', width=2)


def get_game_status(env):
    # Check for win or loss conditions
    for fact in env.facts():
        if fact.template.name == 'you-won':
            return "You won!"
        elif fact.template.name == 'you-lost':
            return "You lost!"
    return ""


def get_player_level(entities):
    for entity in entities:
        if entity['type'] == 'player':
            return entity['level']
    return 1  # Default level if player not found


def filter_entities_by_level(entities, level):
    return [entity for entity in entities if entity['level'] == level]


def get_entities(env):
    entities = []
    for fact in env.facts():
        if fact.template.name in ('inamic', 'lava', 'player', 'intrare', 'diamant', 'iesire'):
            entities.append({
                'type': fact.template.name,
                'level': int(fact[0]),
                'x': int(fact[1]),
                'y': int(fact[2])
            })
    return entities


def update_fact_text(env, fact_text):
    fact_text.delete('1.0', 'end')  # Clear previous content
    for fact in env.facts():
        fact_text.insert('end', str(fact) + '\n')

def main():
    root = Tk()
    root.title("Game")

    env = clips.Environment()
    env.load('mainProject.clp')
    env.reset()

    # Create text widget to display facts
    fact_text = Text(root, font=('Comic Sans MS', 11), bg="gray20", fg="white", height=20, width=20)
    fact_text.grid(row=1, column=0, rowspan=1, padx=10, pady=0)

    grid_size = 5  # Set according to the known grid size
    game_grid = GameGrid(root, grid_size, env, fact_text)

    while game_grid.start_flag == 0:
        entities = get_entities(env)
        current_level = get_player_level(entities)
        filtered_entities = filter_entities_by_level(entities, current_level)
        game_status = get_game_status(env)

        game_grid.update_entities(filtered_entities, current_level, game_status)
        update_fact_text(env, fact_text)
        root.update()  # Update the GUI without blocking

    if game_grid.start_flag == 1:
        while True and game_grid.start_flag == 1:
            env.run(1)  # Run a single step in the CLIPS environment
            entities = get_entities(env)
            current_level = get_player_level(entities)
            filtered_entities = filter_entities_by_level(entities, current_level)
            game_status = get_game_status(env)

            game_grid.update_entities(filtered_entities, current_level, game_status)
            update_fact_text(env, fact_text)
            root.update()  # Update the GUI without blocking
            time.sleep(0.1)
            if game_status:
                time.sleep(10000000)  # Display the message for one second

                break  # Exit the loop after the delay

    root.destroy()  # Close the application window


if __name__ == '__main__':
    main()
