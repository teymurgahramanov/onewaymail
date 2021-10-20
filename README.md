# OneWayMail
Postfix server configured only to send mails. Suitable for 'no-reply' type accounts.

## Features
- Easy usage
- Client authentication
- Network restriction
- No incoming mail
- Security settings

## Usage

### Docker Run
```
docker run --rm -d -p 25:25 -e MAIL_DOMAIN='yourDomain.az' -e MAIL_HOST='mail.yourDomain.az' -e SMTP_USER='yourUser:yourPass' -e ALLOWED_NETWORKS='192.168.1.0/24,172.78.0.0/16,10.10.10.10/32' teymurgahramanov/onewaymail:latest
```

### Docker Compose
```
version: '3'

services:
  mail:
    container_name: mail
    image: teymurgahramanov/onewaymail:latest
    restart: on-failure
    environment:
      - MAIL_DOMAIN=yourDomain.az
      - MAIL_HOST=mail.yourDomain.az
      - SMTP_USER=yourUser:yourPass
      - ALLOWED_NETWORKS=192.168.1.0/24,172.78.0.0/16,10.10.10.10/32
    ports:
      - "25:25"
    volumes:
      - /etc/localtime:/etc/localtime:ro
```
## TODO
- TLS with custom cert