#!/bin/dash
#service openresty start


sed -i -e '1aCATALINA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005' bin/catalina.sh

tail bin/catalina.sh

bin/catalina.sh stop
bin/catalina.sh run
