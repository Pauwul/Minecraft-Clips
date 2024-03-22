# Minecraft system to make decisions with CLIPS engine

In order to use this project, run it or contribute to it, please follow the following steps:

## Using the docker image that I created

This is the _recommended_ way of doing things. All you need is docker. (docker desktop)

```bash
# This will build the docker image
docker build -t minecraft-clips-env .

# This runs the container once you pushed the code and the image is built
docker run -it --rm minecraft-clips-env
# -it runs the container in an interactive manner, so we can bash into it and do other stuff
# --rm removes the container once it's stopped

# Alternatively, you can simply run it in a volume, which is some memory on your system that is mounted on the container
docker run -it --rm -v /path/to/your/code:/app minecraft-clips-env
# replace /path/to/your/code:/app with the path on your system


# You can change minecraft-clips-env with whatever you want your container to be called
```

## Using local development

0. Have python installed(you might have to use python3 instead of python in the commands below)

1. Make sure to use a virtual environment(venv), in order to have the same versions of the pip modules

```bash
# install the virtualenv module
pip install virtualenv

# in order to create a new one: python -m venv envname
# but you don't have to create a new one, as I already created one: mineclipsenv

# to activate the virtual env:
# MacOS / Linux
source mineclipsenv/bin/activate

# Windows
env/Scripts/activate.bat # In CMD
env/Scripts/Activate.ps1 #In Powershel


```

2. Install the necessary requirements

```bash
python install -r requirements.txt


```
