#!/bin/bash

# Définition du mot de passe root de MySQL
DATABASE_PASS='admin123'

# Mise à jour du système
sudo dnf update -y

# Installation des outils nécessaires
sudo dnf install git zip unzip -y

# Installation du serveur MariaDB (version 10.5)
sudo dnf install mariadb105-server -y

# Démarrage et activation automatique du service MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Clonage du dépôt contenant le projet vProfile
cd /tmp/
git clone -b main https://github.com/hkhcoder/vprofile-project.git

# Configuration du mot de passe root pour MySQL
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DATABASE_PASS'"

# Suppression des utilisateurs anonymes et des accès non sécurisés
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Création de la base de données "accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"

# Attribution des droits d'accès à l'utilisateur 'admin'
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"

# Restauration des données à partir de la sauvegarde du projet
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql

# Rafraîchissement des privilèges
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"