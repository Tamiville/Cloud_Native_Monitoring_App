## Defining the BaseImage (gotten from dockerhub@python)
FROM python:3.9-buster

## Set Working directory in the container
WORKDIR /app

## === The container has to have all the dependencies === ##
## Thus copy requirements.txt over to the working dir/Dockerfile ##
COPY requirements.txt .

## Installing Python packages - everything in requirements.txt ##
RUN pip3 install --no-cache-dir -r requirements.txt

## Copy the application code to the working directory ##
## Thats - everything in this dir to app/WORKDIR ##
COPY . .

## Set the application variables for the flask app ##
## Set host to 0.0.0.0 to avoid any restrictions & can run anywhere ##
ENV FLASK_RUN_HOST=0.0.0.0

## Expose the port on which the Flask app will run ###
EXPOSE 5000

## Start the Flask app to run  the container ##
CMD ["flask", "run"]