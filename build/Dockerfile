FROM ubuntu
ENV MAIL_DOMAIN='example.com'
ENV MAIL_HOST='mail.example.com'
ENV SMTP_USER='user:pass'
ENV TLS_ENABLE='NO'
RUN apt update -y && apt install -y postfix postfix-pcre sasl2-bin && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /tmp/
EXPOSE 25
ENTRYPOINT ["/bin/sh","/tmp/entrypoint.sh"]