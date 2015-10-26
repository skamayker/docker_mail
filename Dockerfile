FROM ubuntu:14.04

MAINTAINER Yuriy Safargaliev
RUN apt-get update; apt-get install wget -y
# Install 
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y ca-certificates \ 
    postfix \
    postfix-mysql \
    dovecot-imapd \
    dovecot-pop3d \
    dovecot-mysql \
    ssh \
    curl \
    apache2 \
    libapache2-mod-php5 \
    php5-mysql \
    php5-gd \
    php5-curl \
    php5-imap\
    php-pear \
    libapache2-svn \
    vim \
    mysql-client \
    openssh-server \
    dovecot-sieve \
    dovecot-managesieved \
    rsyslog \
    php-apc && \
    rm -rf /var/lib/apt/lists/*
# SSH configuration
RUN mkdir /var/run/sshd
RUN echo 'root:tu3ahyiH' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN php5enmod imap
ENV ALLOW_OVERRIDE **False**

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD dovecot/ /etc/dovecot
ADD postfix/ /etc/postfix
ADD postfix.mysql /tmp/schema.sql
ADD db_install.sh /usr/local/bin/db_install.sh
RUN chmod +x /usr/local/bin/db_install.sh
ADD postfixadmin /var/www/html/postfixadmin
RUN chown -R www-data:www-data /var/www/html
ADD php.ini /etc/php5/apache2/php.ini
#Backup
# mail directory
# Define default command.
CMD ["/run.sh"]

# Expose ports.
EXPOSE 25 80 110 143 443 465 587 993 995 22

