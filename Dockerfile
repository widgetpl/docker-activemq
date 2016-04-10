FROM oberthur/docker-ubuntu-java:jdk8_8.71.15

MAINTAINER Dawid Malinowski <d.malinowski@oberthur.com>

ENV HOME=/opt/app
ENV ACTIVEMQ_VERSION 5.12.2
WORKDIR /opt/app

ADD start-activemq.sh /bin/start-activemq.sh

# Install activemq
RUN chmod +x /bin/start-*.sh \
    && curl -LO https://www.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
    && gunzip apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz \
    && tar -xf apache-activemq-${ACTIVEMQ_VERSION}-bin.tar -C /opt/app \
    && mv apache-activemq-*/ apache-activemq/ \
    && chmod -x apache-activemq/bin/activemq \
    && mv apache-activemq/conf/activemq.xml apache-activemq/conf/activemq.xml.orig \
    && awk '/.*stomp.*/{print " <transportConnector name=\"stompssl\" uri=\"stomp+nio+ssl://0.0.0.0:61612?transport.enabledCipherSuites=SSL_RSA_WITH_RC4_128_SHA,SSL_DH_anon_WITH_3DES_EDE_CBC_SHA\" />"}1' apache-activemq/conf/activemq.xml.orig >> apache-activemq/conf/activemq.xml \
    && rm apache-activemq-$ACTIVEMQ_VERSION-bin.tar

# Add user app
RUN echo "app:x:999:999::/opt/app:/bin/false" >> /etc/passwd; \
    echo "app:x:999:" >> /etc/group; \
    mkdir -p /opt/app; chown app:app /opt/app

EXPOSE 61612 61613 61616 8161

ENTRYPOINT ["/bin/start-activemq.sh"]
