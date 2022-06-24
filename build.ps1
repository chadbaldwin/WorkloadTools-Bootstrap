# build the image ahead of time so that we can reference it by name in the docker-compose file
docker build -t wwisql .

# sample run command to spin up a single instance of image
#docker run -d -p 1433:1433 --name sql wwisql