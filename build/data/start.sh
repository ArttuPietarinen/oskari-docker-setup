#!/bin/dash
. "$(dirname "$0")/secrets.sh"

sed -i '
    s|<Property name="LOG_DIR">logs</Property>|<Property name="LOG_DIR">/usr/local/tomcat/logs</Property>|g;
    ' "$OSKARI_CONFIGS/log4j2.xml"

sed -i "
    s|DB_PASSWORD|$DB_PASSWORD|g;
    s|DB_USERNAME|$DB_USERNAME|g;
    s|VKM_API_KEY|$VKM_API_KEY|g;
    s|RATATIEDOT_USER|$RATATIEDOT_USER|g;
    s|RATATIEDOT_PASS|$RATATIEDOT_PASS|g;
    s|DB_URL|$DB_URL|g;
    s|DB_USERNAME|$DB_USERNAME|g;
    s|DB_PASSWORD|$DB_PASSWORD|g;
    s|BASE_URL|$BASE_URL|g;
    s|BASE_PATH|$BASE_PATH|g;
    s|GEOSERVER_URL|$GEOSERVER_URL|g;
    s|GEOSERVER_USER|$GEOSERVER_USER|g;
    s|GEOSERVER_PASS|$GEOSERVER_PASS|g;
    s|REDIS_HOST|$REDIS_HOST|g;
    s|VKM_API_KEY|$VKM_API_KEY|g;
    s|VKM_API_URL|$VKM_API_URL|g;
    s|DOWNLOAD_TEMP_FOLDER|$DOWNLOAD_TEMP_FOLDER|g;
    s|SFTP_USERNAME|$SFTP_USERNAME|g;
    s|SFTP_PRIVATE_KEY|$SFTP_PRIVATE_KEY|g;
    s|SFTP_REMOTE_HOST|$SFTP_REMOTE_HOST|g;
    s|SFTP_REMOTE_FOLDER|$SFTP_REMOTE_FOLDER|g;
    s|RATATIEDOT_USER|$RATATIEDOT_USER|g;
    s|RATATIEDOT_PASS|$RATATIEDOT_PASS|g;
    s|NLSFI_GEOCODING_APIKEY|$NLSFI_GEOCODING_APIKEY|g;
    s|oskari.profiles=awsauth, redis-session, redis-aws|oskari.profiles=LoginDatabase|g;
    s|vayla.login.hide = true|#vayla.login.hide = true|g;
    s|ADDITIONAL_MODULES|,localhost|g;
    s|redis.hostname=REDIS_HOST|#redis.hostname=REDIS_HOST|g;
    s|redis.port=6379|#redis.port=6379|g;
    s|redis.pool.size=10|#redis.pool.size=10|g;
    s|RASTERIPALVELU_URL|https://avoin-paikkatieto.maanmittauslaitos.fi/geocoding|g;
    s|NLSFI_GEOCODING_URL|https://avoin-paikkatieto.maanmittauslaitos.fi/geocoding|g;
    s|8b65cd2c-9f8c-474d-93db-56788131d3e2|0638b19d-807c-472f-b904-d62f9ba7e03f|g;
    s|search.channels=NLSFI_GEOCODING, METADATA_CATALOGUE_CHANNEL,VKMSearch, OPENSTREETMAP_CHANNEL|search.channels=NLSFI_GEOCODING, METADATA_CATALOGUE_CHANNEL,VKMSearch|g;
    s|oskari.ajax.url.prefix=/geoportaali/action?|oskari.ajax.url.prefix=action?|g;
    " "$OSKARI_CONFIGS/oskari-ext.properties"

sed -i "
    s|DB_URL|$DB_URL|g;
    s|DB_USERNAME|$DB_USERNAME|g;
    s|DB_PASSWORD|$DB_PASSWORD|g;
    " "$CATALINA_HOME/conf/context.xml"

sed  -i '/<\/Context>/a \<Context path="/BASE_PATH/Oskari" docBase="OSKARI_FRONT" />' "$CATALINA_HOME/conf/server.xml"

sed -i "
  s|DB_PASSWORD|$DB_PASSWORD|g;
  s|DB_USERNAME|$DB_USERNAME|g;
  s|OSKARI_FRONT|/oskari-front|g;
  s|OSKARI_CONFIGS|$OSKARI_CONFIGS|g;
  s|BASE_PATH|$BASE_PATH|g;
  " "$CATALINA_HOME/conf/server.xml"


sed -i "
    s|BASE_PATH|oskari-map|g;
    s|MML_API_URL|$MML_API_URL|g;
    s|MML_API_KEY|$MML_API_KEY|g;
    s|PAIKKATIEDOT_API_URL|$PAIKKATIEDOT_API_URL|g;
    s|PAIKKATIEDOT_API_KEY|$PAIKKATIEDOT_API_KEY|g;
    s|RASTERIPALVELU_API_URL|$RASTERIPALVELU_API_URL|g;
    s|RASTERIPALVELU_API_KEY|$RASTERIPALVELU_API_KEY|g;
    s|RESOLVER_IP|$RESOLVER_IP|g;
    s|OSKARI_FRONT|$OSKARI_FRONT|g;
    " /usr/local/openresty/nginx/conf/nginx.conf

service openresty start
bin/catalina.sh stop
bin/catalina.sh run
