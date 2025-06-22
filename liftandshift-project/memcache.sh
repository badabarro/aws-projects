#!/bin/bash

# Installation du service Memcached
sudo dnf install memcached -y

# Démarrage du service Memcached
sudo systemctl start memcached

# Activation du démarrage automatique au boot
sudo systemctl enable memcached

# Vérification de l’état du service
sudo systemctl status memcached

# Modification de la configuration pour autoriser l'accès distant
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

# Redémarrage du service pour appliquer les modifications
sudo systemctl restart memcached

# Lancement manuel du service (optionnel, car déjà lancé par systemd)
sudo memcached -p 11211 -U 11111 -u memcached -d
