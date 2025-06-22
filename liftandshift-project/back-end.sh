#!/bin/bash

# Définition du mot de passe MySQL root
DATABASE_PASS='admin123'



# Activation du dépôt EPEL (Extra Packages for Enterprise Linux)
yum install epel-release -y

# Installation de Memcached
yum install memcached -y

# Démarrage et activation du service Memcached
systemctl start memcached
systemctl enable memcached

# Vérification de l’état du service
systemctl status memcached

# Lancement manuel en mode daemon
memcached -p 11211 -U 11111 -u memcached -d




# Installation des dépendances nécessaires
yum install socat -y
yum install erlang -y
yum install wget -y

# Téléchargement de RabbitMQ (version 3.6.10)
wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server-3.6.10-1.el7.noarch.rpm

# Importation de la clé de signature officielle
rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc

# Mise à jour du système
yum update -y

# Installation du paquet RabbitMQ
rpm -Uvh rabbitmq-server-3.6.10-1.el7.noarch.rpm

# Démarrage et activation du service RabbitMQ
systemctl start rabbitmq-server
systemctl enable rabbitmq-server
systemctl status rabbitmq-server

# Autorisation des connexions extérieures (désactivation des restrictions loopback)
echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

# Création d’un utilisateur RabbitMQ avec droits d’administrateur
rabbitmqctl add_user rabbit bunny
rabbitmqctl set_user_tags rabbit administrator

# Redémarrage du service pour appliquer la configuration
systemctl restart rabbitmq-server




# Installation du serveur MariaDB
yum install mariadb-server -y

# Modification de la configuration pour accepter les connexions distantes
sed -i 's/^127.0.0.1/0.0.0.0/' /etc/my.cnf

# Démarrage et activation du service MariaDB
systemctl start mariadb
systemctl enable mariadb

# Définition du mot de passe root et sécurisation de l’installation
mysqladmin -u root password "$DATABASE_PASS"
mysql -u root -p"$DATABASE_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DATABASE_PASS') WHERE User='root'"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Création de la base de données "accounts" et ajout des privilèges utilisateur
mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'app01' identified by 'admin123'"

# Restauration des données depuis le fichier de sauvegarde
mysql -u root -p"$DATABASE_PASS" accounts < /vagrant/vprofile-repo/src/main/resources/db_backup.sql

# Rafraîchissement des privilèges
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Redémarrage du service MariaDB
systemctl restart mariadb
