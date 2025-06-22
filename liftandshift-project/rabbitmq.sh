#!/bin/bash

# Importation de la clé de signature principale de RabbitMQ
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc'

# Importation de la clé du dépôt Erlang (nécessaire à RabbitMQ)
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key'

# Importation de la clé du dépôt RabbitMQ Server
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key'

# Ajout du fichier de configuration du dépôt YUM pour RabbitMQ
curl -o /etc/yum.repos.d/rabbitmq.repo https://raw.githubusercontent.com/hkhcoder/vprofile-project/refs/heads/awsliftandshift/al2023rmq.repo

# Mise à jour des paquets
dnf update -y

# Installation des dépendances nécessaires
dnf install socat logrotate -y

# Installation d'Erlang (dépendance) et du serveur RabbitMQ
dnf install -y erlang rabbitmq-server

# Activation du service RabbitMQ au démarrage
systemctl enable rabbitmq-server

# Démarrage du service RabbitMQ
systemctl start rabbitmq-server

# Configuration pour autoriser les connexions autres que localhost (désactivation de loopback_users)
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

# Création d’un utilisateur test avec mot de passe
sudo rabbitmqctl add_user test test

# Attribution du rôle administrateur à l’utilisateur test
sudo rabbitmqctl set_user_tags test administrator

# Définition des permissions complètes pour l'utilisateur test
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

# Redémarrage du service pour appliquer les changements
sudo systemctl restart rabbitmq-server
