#!/bin/bash
mysql -u root -h mysql -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD -e "create database postfix"
mysql -u root -h mysql -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD postfix < /tmp/schema.sql
