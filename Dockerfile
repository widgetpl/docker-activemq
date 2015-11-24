FROM oberthur/docker-alpine-java:jdk8_8.65.17

MAINTAINER Dawid Malinowski <d.malinowski@oberthur.com>

ENV HOME=/opt/app
ENV ACTIVEMQ_VERSION 5.11.1
WORKDIR /opt/app

# Install activemq
RUN curl -O -L http://www.eu.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz -o apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
    && gunzip apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
    && tar -xf apache-activemq-${ACTIVEMQ_VERSION}-bin.tar -C /opt/app \
    && mv apache-activemq-*/ apache-activemq/ \
    && chmod -x apache-activemq/bin/activemq \
    && mv apache-activemq/conf/activemq.xml apache-activemq/conf/activemq.xml.orig \
    && sed -i -e "s/<storeUsage limit=\"100 gb\"\/>/<storeUsage limit=\"10 gb\"\/>/" apache-activemq/conf/activemq.xml.orig \
    && sed -i -e "s/<tempUsage limit=\"50 gb\"\/>/<tempUsage limit=\"5 gb\"\/>/" apache-activemq/conf/activemq.xml.orig \
    && awk '/.*stomp.*/{print " <transportConnector name=\"stompssl\" uri=\"stomp+nio+ssl://0.0.0.0:61612?transport.enabledCipherSuites=SSL_RSA_WITH_RC4_128_SHA,SSL_DH_anon_WITH_3DES_EDE_CBC_SHA\" />"}1' apache-activemq/conf/activemq.xml.orig >> apache-activemq/conf/activemq.xml

# Add user app
RUN echo "app:x:999:999::/opt/app:/bin/false" >> /etc/passwd; \
    echo "app:x:999:" >> /etc/group; \
    mkdir -p /opt/app; chown app:app /opt/app

EXPOSE 61612 61613 61616 8161

ENTRYPOINT ["java", "-server", "-verbose:gc", "-XX:+UseCompressedOops", "-Djava.util.logging.config.file=logging.properties"]

CMD ["-Xms512m", "-Xmx512m", "-XX:MetaspaceSize=64M", "-XX:MaxMetaspaceSize=64M", \
	"-jar", "/opt/app/apache-activemq/bin/activemq.jar", "start"]
