# OneWayMail
Postfix server configured only for sending mails. Suitable for 'no-reply' accounts.

## Features
- Easy usage
- Client authentication
- No incoming mail
- Security settings

## Usage
docker run --rm -d -p 25:25 -e MAIL_DOMAIN='yourDomain.com' -e MAIL_HOST='mail.yourDomain.com' -e SMTP_USER='yourUser:yourPass' teymurgahramanov/onewaymail

## TODO
- TLS