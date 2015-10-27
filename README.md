# docker_mail 
It is a  mail server with postfixadmin and RainLoop webmail client for simple instalation and configuration. **For use it you need to install docker** [Visit Docker.com](https://www.docker.com/)
After installation of docker you need to execute start_mail.sh with hostname, domainname , root password for database options, for example: 
```{r, engine='bash', count_lines}
sh start_mail.sh mx.example.com example.com mysecretpassword 
```
If your hostname matches with domain name, you need to insert hostname instead domain name
After instalation you  must change the  root password on container with Postfix by executing: docker exec -it $MAIL passwd. After you must login [](http://your_domain_name_or_ip:8081/postfixadmin/login.php) (login: postadmin@example.com; password qazxsw123) and create your domain for postfix and mailboxes. Also you must change password for postadmin@example.com. For use RainLoop Webmail you must login into [](http://your_domain_or_ip:8080/) (login: admin; password 12345) and add your domain (imap 143 port starttls; smtp 25 port starttls). Don't forget to change admin password. Logout and login with your mail account
