#!/bin/bash

# Mise à jour de la liste des paquets disponibles
sudo apt update

# Mise à jour des paquets installés vers leurs dernières versions
sudo apt upgrade -y

# Installation de la version 17 du JDK (Java Development Kit)
sudo apt install openjdk-17-jdk -y

# Installation de Tomcat 10 ainsi que ses modules complémentaires et Git
sudo apt install tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git -y
