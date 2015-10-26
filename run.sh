#!/bin/bash
env | grep _ >> /etc/environment
useradd vmail
chmod 777 /var/vmail
usermod -u 1000 vmail
chown -R vmail: /var/vmail/
rm /etc/dovecot/conf.d/15-mailboxes.conf
echo $HOSTNAME > /etc/mailname
#chmod 600 -R /etc/opendkim/keys/
#postfix prepare
echo "export MYSQL_PORT_3306_TCP_ADDR=mysql" >> /etc/apache2/envvars
echo "export MYSQL_ENV_MYSQL_ROOT_PASSWORD=$MYSQL_ENV_MYSQL_ROOT_PASSWORD" >> /etc/apache2/envvars
echo "user = root" > /etc/postfix/dbpass
echo "password = $MYSQL_ENV_MYSQL_ROOT_PASSWORD" >> /etc/postfix/dbpass
echo "hosts = mysql" >> /etc/postfix/dbpass
echo "dbname = postfix" >> /etc/postfix/dbpass
cat /etc/postfix/dbpass >>  /etc/postfix/mysql/mysql_virtual_alias_domain_catchall_maps.cf
cat /etc/postfix/dbpass >>  /etc/postfix/mysql/mysql_virtual_alias_domain_mailbox_maps.cf
cat /etc/postfix/dbpass >>  /etc/postfix/mysql/mysql_virtual_alias_domain_maps.cf
cat /etc/postfix/dbpass >>  /etc/postfix/mysql/mysql_virtual_alias_maps.cf
cat /etc/postfix/dbpass >>  /etc/postfix/mysql/mysql_virtual_domains_maps.cf
cat /etc/postfix/dbpass >>  /etc/postfix/mysql/mysql_virtual_gid_maps.cf
cat /etc/postfix/dbpass >>  /etc/postfix/mysql/mysql_virtual_mailbox_limit_maps.cf
cat /etc/postfix/dbpass >>  /etc/postfix/mysql/mysql_virtual_mailbox_maps.cf
cat /etc/postfix/dbpass >>  /etc/postfix/mysql/mysql_virtual_uid_maps.cf
#dovecot prepare
echo "connect = host=mysql dbname=postfix user=root password=$MYSQL_ENV_MYSQL_ROOT_PASSWORD" >> /etc/dovecot/dovecot-sql.conf.ext
/etc/init.d/rsyslog start
#/etc/init.d/clamav-freshclam start
postconf -e "myhostname = $HOSTNAME"
postconf -e "mydomain = $MAIL_DOMAINE"
postconf -e "mydestination = localhost.localdomain, localhost"
/etc/init.d/postfix start
service apache2 start
dovecot && chmod 666 /var/log/dovecot.log && chmod 777 /var/run/dovecot/auth-userdb
/usr/sbin/sshd -D

