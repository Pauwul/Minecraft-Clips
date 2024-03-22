# We'll be using the followign python version:
FROM python:3.13-rc-slim

# This sets up the container in which the app is served:
WORKDIR /app

# Copy the contents of the current directory on our local machine to the docker container WORKDIR
COPY . /app 

# Installs the dependencies from our txt file
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install pandas
RUN sudo apt-get install python3-tk
# This assures that the comments we receive in the app are sent directly to the terminal
ENV PYTHONUNBUFFERED 1

# Launch the app
CMD ["python", "app.py"]

