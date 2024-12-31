#Oskari development, contains docker setup for building oskari-server and oskari-frontend
#and sample apps for backend and frontend

Application responds from url:
http://localhost:8080/

## prerequisite
1. Installed docker desktop found on path
2. docker-compose tool installed and found on path


## You can make front-end or backend build faster to use prebuilded packages to save time
### On Dockerfile you need comment / uncomment lines which uses frontbuilder and backendbuilder
### You need to build sample-application manually ( npm i && npm run build ) if you dont use docker frontbuilder
### You need to build sample-server-extension and oskari-server manually ( mvn clean install ) if you dont use docker backendbuilder

## Build all
on root level of repo:
>docker-compose -f build/docker-compose.yaml build

## Run all
>docker-compose -f build/docker-compose.yaml up

## Run with development version of oskari-server
>set oskari.version to latest oskari-server develop version on oskari-server-extensions-geoportal/pom.xml
>set argument OSKARI_DEV to TRUE on build/docker-compose.yaml
>build and run normally, it will use latest oskari-server

## Running certain components independently

### Geoportal backend
#### build
>docker build -t geoportal_tomcat --target tomcat -f Dockerfile .
#### run
>docker run geoportal_tomcat


### Database
#### build
>docker build -t geoportal_database --target database -f Dockerfile .

### run
>docker run geoportal_database