# Docker image containing ActiveMQ
Basic Docker image to run activemq as user app (999:999)

You need edit (add) this env:

*General*

- **STORE_USAGE**: value in GB (default value is `10`)
- **TEMP_USAGE**: value in GB (default value is `5`)
- **ADMIN_PASSWORD**: provide admin password (default `admin123`)

*Networking*

- **PORT_OPENWIRE**: port for openwire connection (default value is `61616`)
- **PORT_AMQP**: port for AMQP connection (default value is `5672`)
- **PORT_STOMPSSL**: port for stomp/SSL connection (default value is `61612`)
- **PORT_STOMP**: port for stomp connection (default value is `61613`)
- **PORT_MQTT**: port for MQTT connection (default value is `1883`)
- **PORT_WS**: port for WebSocket connection (default value is `61614`)
- **NETWORK_OF_BROKERS_CONNECTORS_URI**: possibility to configure network of brokers. As this env variable is part of `sed` command it needs to escape all special characters like in `sed` f.e.:

```export NETWORK_OF_BROKERS_CONNECTORS_URI=static:(tcp:\/\/10.122.17.157:61616)```

*Logging:*

- **ROOT_LOGGER_LEVEL** - changes `log4j.rootLogger` (default value: `INFO, console, logfile`)
- **ACTIVEMQ_SPRING_LOGGER_LEVEL** - changes `log4j.logger.org.apache.activemq.spring` (default value: `WARN`)
- **ACTIVEMQ_WEB_HANDLER_LOGGER_LEVEL** - changes `log4j.logger.org.apache.activemq.web.handler` (default value: `WARN`)
- **SPRINGFRAMEWORK_LOGGER_LEVEL** - changes `log4j.logger.org.springframework` (default value: `WARN`)
- **CAMEL_LOGGER_LEVEL** - changes `log4j.logger.org.apache.camel` (default value: `INFO`)
- **CONSOLE_APPENDER_THRESHOLD_LEVEL** - changes `log4j.appender.console.threshold` (default value: `INFO`)

If you want web console you should expose:
- **8161**: if you need plain http connection
- **8162**: if you need ssl connection
