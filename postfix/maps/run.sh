#!/bin/bash
syslogd
mkdir /var/spool/virtualmailboxes/
echo "mail.$DOMAIN" > /etc/hostname
echo "127.0.0.2 mail.$DOMAIN" >> /etc/hosts
echo "virtualmail:x:1000:1000::/var/spool/virtualmailboxes:/sbin/nologin" >> /etc/passwd
echo "virtualmail:x:1000:" >> /etc/group
chmod 700 /var/spool/virtualmailboxes/
chown -R virtualmail:virtualmail /var/spool/virtualmailboxes/
rm -f /usr/lib/sendmail
ln -s /usr/sbin/sendmail /usr/lib/sendmail
echo "INSERT INTO domain ( domain, description, transport )
VALUES ( '$DOMAIN', 'kt', 'virtual' );" |sqlite3 /etc/postfix/postfix.sqlite
echo "INSERT INTO mailbox ( username, password, name, maildir, domain, local_part ) 
VALUES ( '$NAME@$DOMAIN', '$PASS', '$NAME', '$DOMAIN/$NAME@$DOMAIN/', '$DOMAIN', '$NAME' );" |sqlite3 /etc/postfix/postfix.sqlite
echo "INSERT INTO alias ( address, goto, domain )
VALUES ( '$NAME@$DOMAIN', '$NAME@$DOMAIN', '$DOMAIN' );" |sqlite3 /etc/postfix/postfix.sqlite
/usr/sbin/postfix start
tail -f /dev/null