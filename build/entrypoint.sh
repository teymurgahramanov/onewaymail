#Postfix
postconf -e myhostname=$MAIL_HOST
postconf -e mydestination=$MAIL_DOMAIN,$MAIL_HOST,localhost,localhost.localdomain
postconf -e myorigin=$MAIL_DOMAIN
postconf -e maillog_file=/dev/stdout
postconf -e inet_protocols=ipv4
postconf -e smtpd_sasl_auth_enable=yes
postconf -e broken_sasl_auth_clients=yes
postconf -e smtpd_recipient_restrictions=permit_sasl_authenticated,reject_unauth_destination
postconf -e strict_rfc821_envelopes=yes
postconf -e show_user_unknown_table_name=no
postconf -e smtpd_helo_required=yes
postconf -e smtp_always_send_ehlo=yes
postconf -e smtpd_hard_error_limit=3
postconf -e smtpd_error_sleep_time=10s
postconf -e smtpd_timeout=60s
postconf -e smtp_helo_timeout=30s
postconf -e smtp_mail_timeout=30s
postconf -e smtp_rcpt_timeout=30s
postconf -e unverified_sender_reject_code=550
postconf -e unknown_local_recipient_reject_code=550
postconf -e smtp_header_checks=pcre:/etc/postfix/smtp_header_checks
postconf -e virtual_alias_maps=hash:/etc/postfix/virtual
cat >> /etc/postfix/smtp_header_checks << EOF
/^Received: .*/     IGNORE
/^X-Originating-IP:/    IGNORE
/^X-Mailer:/            IGNORE
/^Mime-Version:/        IGNORE
EOF
echo 'null: /dev/null' > /etc/aliases
echo $SMTP_USER | tr , \\n > /tmp/users
while IFS=':' read -r _user _pass; do
  echo "$_user@$MAIL_DOMAIN null" > /etc/postfix/virtual
done < /tmp/users
newaliases
postmap /etc/postfix/virtual
postconf -F '*/*/chroot = n'

#TLS (NOT TESTED)
if [ $TLS_ENABLE = 'YES' ]; then
  mkdir /etc/postfix/tls && chown postfix /etc/postfix/tls && chmod 400 /etc/postfix/tls
  postconf -e smtpd_use_tls=yes
  postconf -e smtpd_tls_key_file=/etc/postfix/tls/cert.pem
  postconf -e smtpd_tls_cert_file=/etc/postfix/tls/key.pem
  postconf -e smtpd_tls_CAfile=/etc/postfix/tls/ca.pem
  postconf -e smtpd_tls_security_level=encrypt
  postconf -e smtpd_tls_loglevel=0
  postconf -e smtpd_tls_received_header=yes
  postconf -e smtpd_tls_session_cache_timeout=3600s
  postconf -e smtp_use_tls=yes
  postconf -e smtp_tls_key_file=/etc/postfix/tls/cert.pem
  postconf -e smtp_tls_cert_file=/etc/postfix/tls/key.pem
  postconf -e smtp_tls_CAfile=/etc/postfix/tls/ca.pem
  postconf -e smtp_tls_security_level=encrypt
  postconf -e smtp_tls_loglevel=0
  postconf -e smtp_tls_session_cache_timeout=3600s
  postconf -e tls_random_source=dev:/dev/urandom
fi

#SASL
cat >> /etc/postfix/sasl/smtpd.conf <<EOF
pwcheck_method: auxprop
auxprop_plugin: sasldb
mech_list: PLAIN LOGIN CRAM-MD5 DIGEST-MD5 NTLM
EOF
echo $SMTP_USER | tr , \\n > /tmp/users
while IFS=':' read -r _user _pass; do
  echo $_pass | saslpasswd2 -p -c -u $MAIL_DOMAIN $_user
done < /tmp/users
chown postfix:sasl /etc/sasldb2

###
rm -f /tmp/users
postfix start-fg