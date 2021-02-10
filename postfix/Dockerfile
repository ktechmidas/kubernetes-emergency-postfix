FROM alpine
RUN apk add postfix bash sqlite dovecot postfix-sqlite
EXPOSE 25
COPY run.sh /run.sh
COPY sqlite.dmp /
COPY maps /etc/postfix/
COPY main.cf /etc/postfix/main.cf
RUN chmod +x /run.sh
RUN cat /sqlite.dmp | sqlite3 /etc/postfix/postfix.sqlite
CMD ["/run.sh"]