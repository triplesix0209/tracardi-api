FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9
MAINTAINER office@tracardi.com

RUN apt-get update
RUN apt-get install -y git

# update pip
RUN /usr/local/bin/python3 -m pip install --upgrade pip

# set the working directory in the container
RUN mkdir app/
WORKDIR /app

## Install dependencies
COPY app/requirements.txt .
RUN pip install wheel
RUN pip --default-timeout=240 install -r requirements.txt

RUN pip show tracardi
RUN pip list


## Copy application
COPY app app/
COPY uix uix/

## Copy manual
COPY docs manual/

# Remove test page

RUN rm -rf app/tracker/index.html
RUN rm -rf app/tracker/index.css

## Install dependencies
RUN pip --default-timeout=240 install -r manual/requirements.txt

# Install manual
WORKDIR /
RUN mkdocs build

WORKDIR /app
ENV VARIABLE_NAME="application"
