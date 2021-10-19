# OneWayMail
Postfix server with client authentication configured only to send mails. Suitable for 'no-reply' type mails.

## Features
- Easy usage
- Client authentication
- No incoming mail
- Security settings

## Usage
docker run --rm -d -p 25:25 -e MAIL_DOMAIN='yourDomain.com' -e MAIL_HOST='mail.yourDomain.com' -e SMTP_USER='yourUser:yourPass' teymurgahramanov/onewaymail

## TODO
- TLS with custom cert
