# oskari frontend build
FROM node:16-alpine3.16 as frontbuilder
COPY ./sample-application /oskari-front
COPY ./oskari-frontend /oskari-frontend
#RUN apk add g++ make py3-pip
RUN cd /oskari-front && \
    npm ci && \
    npm run build


#maven backend build container
# set to true if you want to use develop against local oskari-server version, then you need to also change oskari version to
# same as lates oskari-server develop on oskari-server-extensions-geoportal/pom.xml, oskari.version prop
ARG OSKARI_DEV
FROM --platform=linux/x86_64 maven:3.9.9-eclipse-temurin-17-alpine as backendbuilder
COPY ./sample-server-extension/ /oskari
COPY ./oskari-server/ /oskari-server
#COPY ./oskari-server /oskari-server only for testing with locally pulled oskari-server
RUN if [ "$OSKARI_DEV" = true ] ; then     apk update && \
                                           apk add --update-cache git && \
                                           git clone https://github.com/oskariorg/oskari-server.git && \
                                           cd oskari-server && \
                                           git checkout develop ; fi

# cd /oskari-server && \
# mvn clean install -Dmaven.test.skip=true && \
RUN cd /oskari-server && \
    mvn clean install -Dmaven.test.skip=true
RUN cd /oskari && \
    mvn clean install -Dmaven.test.skip=true

#Postgis image
FROM kartoza/postgis:latest as databaseq
WORKDIR .
COPY ./build/data/healthcheck.sh .
EXPOSE 5432

##Geoserver image
FROM kartoza/geoserver:latest as geoserver
WORKDIR .
EXPOSE 8086:8080

FROM jetty:10-jdk17-alpine-amazoncorretto as tomcat
#FROM jetty:12-jdk17-amazoncorretto as tomcat # käynnistyy mutta sovellusta ei löydy
#FROM jetty:9-jre8 as tomcat #TOImii

ENV OSKARI_FRONT=/oskari-front
ENV OSKARI_CONFIGS=/oskari-configs
##uncomment following line ( and comment line after that one) if you want docker to build frontend,
##otherwise you need to build front sample-application first
#COPY --from=frontbuilder /oskari-front/dist $OSKARI_FRONT/dist
COPY ./sample-application/dist /oskari-front/dist/
##comment out next line and uncomment line 55 if you want to build oskari-server manually
COPY --from=backendbuilder /oskari/webapp-map/target/oskari-map.war $JETTY_BASE/webapps/
#COPY  ./sample-server-extension/webapp-map/target/oskari-map.war $JETTY_BASE/webapps/

COPY build/data/jetty/oskari-ext.properties $JETTY_BASE/resources/
COPY build/data/jetty/start.sh $JETTY_HOME
COPY build/data/jetty/postgresql-42.7.4.jar $JETTY_BASE/lib/ext/
COPY build/data/jetty/oskari-front.xml $JETTY_BASE/webapps/
COPY build/data/jetty/oskari-map.xml $JETTY_BASE/webapps/
COPY build/data/jetty/webdefault.xml $JETTY_BASE/etc/

#RUN java -jar $JETTY_HOME/start.jar --add-module=server,http,deploy
CMD java -jar $JETTY_HOME/start.jar
#CMD ["sh", "-e", "start.sh"]
EXPOSE 8080 8081 80
