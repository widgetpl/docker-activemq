# Docker image containing ActiveMQ
Basic Docker image to run activemq as user app (999:999)

You need edit (add) this env:
- **STORE_USAGE**: value in GB (default value is 10)
- **TEMP_USAGE**: value in GB (default value is 5)
- **ADMIN_PASSWORD**: provide admin password (default admin123)

If you want web console you should expose:
- **8161**: if you need plain http connection
- **8162**: if you need ssl connection