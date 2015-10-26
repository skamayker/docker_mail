#!/bin/bash
if [  $# -le 0 ];then
	echo "######################################################################################################################"
	echo "# Enter hostname, name of domain, root password for database                                                         #"
	echo "# ./start_mail.sh mx.example.com example.com mysecretpassword                                                        #"
	echo "######################################################################################################################"
	exit 1
fi

HOST=$1
MAIL=$2
PWD=$3

docker pull mysql:5.5
docker pull zlid/mail.store
docker run --name=$MAIL.store -dt zlid/mail.store
docker run --name=mysql -e MYSQL_ROOT_PASSWORD=$PWD -dt mysql:5.5
echo "auth_realms = $MAIL" >> dovecot/conf.d/10-auth.conf
echo "auth_default_realm = $MAIL" >> dovecot/conf.d/10-auth.conf

docker build -t mailserver .
docker run  -p 25:25 -p 143:143 -p 993:993 -p 465:465 -p 587:587 -p 4322:22 -p 8081:80 --name=$MAIL --hostname=$HOST -e MAIL_DOMAINE=$MAIL  --volumes-from=$MAIL.store --link=mysql:mysql -d -t mailserver
docker exec $MAIL db_install.sh
docker pull jprjr/rainloop
docker run -e NGINX=1  --name=rainloop.mail.client -d  -p 8080:80 jprjr/rainloop

echo "####################################################################################################################################"
echo "# You must change the  root password on container with Postfix by executing: docker exec -it $MAIL passwd. After you must login    #"
echo "# in postfixadmin http://your_domain_name_or_ip:8081/postfixadmin/login.php (login: postadmin@example.com; password qazxsw123) and #"
echo "# create your domain for postfix and mailboxes. Also you must change password for postadmin@example.com. For use RainLoop Webmail  #"
echo "# you must login into http://your_domain_or_ip:8080/ (login: admin; password 12345) and add your domain (imap 143 port starttls;   #"
echo "# smtp 25 port starttls). Logout and login with your mail account                                                                  #"
echo "####################################################################################################################################"