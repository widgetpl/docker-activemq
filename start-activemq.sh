#!/bin/bash
set -e
set -x

STORE_USAGE=${STORE_USAGE:=10}
TEMP_USAGE=${TEMP_USAGE:=5}
ADMIN_PASSWORD=${ADMIN_PASSWORD:=admin123}

sed -i -e "s/<storeUsage limit=\"100 gb\"\/>/<storeUsage limit=\"${STORE_USAGE} gb\"\/>/" /opt/app/apache-activemq/conf/activemq.xml
sed -i -e "s/<tempUsage limit=\"50 gb\"\/>/<tempUsage limit=\"5 gb\"\/>/" /opt/app/apache-activemq/conf/activemq.xml

sed -i -e "s/admin activemq/admin ${ADMIN_PASSWORD}/" /opt/app/apache-activemq/conf/jmx.password
sed -i -e "s/admin: admin, admin/admin: ${ADMIN_PASSWORD}, admin/" /opt/app/apache-activemq/conf/jetty-realm.properties
sed -i -e 's/user: user, user//' /opt/app/apache-activemq/conf/jetty-realm.properties

JVM_OPTS="-server -verbose:gc -XX:+UseCompressedOops -Xms512m -Xmx512m -XX:MetaspaceSize=64M -XX:MaxMetaspaceSize=64M"

exec java ${JVM_OPTS} -Djava.util.logging.config.file=logging.properties -jar /opt/app/apache-activemq/bin/activemq.jar start