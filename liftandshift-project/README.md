# Projet DevOps – Déploiement d'une Application Web Java sur AWS

Ce projet illustre la mise en place complète d'une infrastructure cloud permettant de déployer une application web Java (vProfile) sur Amazon Web Services (AWS), en utilisant EC2, S3, Route 53, un Load Balancer, et Auto Scaling.

---

## 🎯 Objectif

Mettre en œuvre une architecture distribuée et scalable sur AWS pour héberger une application Java avec plusieurs services back-end (MySQL, Memcached, RabbitMQ) et un front-end Tomcat, en utilisant des scripts d’automatisation et des services managés d’AWS.

---

## 🛠️ Prérequis

- Un compte AWS actif
- Un utilisateur IAM avec les autorisations nécessaires
- Git Bash ou Terminal
- Accès SSH configuré

---

## 📐 Architecture du Projet

L’architecture se compose des éléments suivants :

- EC2 Instances :
  - `vprofile-db01` (MySQL)
  - `vprofile-mc01` (Memcached)
  - `vprofile-rmq01` (RabbitMQ)
  - `vprofile-app01` (Tomcat)
- Load Balancer (ELB)
- Auto Scaling Group
- Route 53 pour la gestion DNS
- S3 pour stockage des artefacts
- IAM pour sécuriser l’accès


---

## 🚀 Déploiement des Services sur EC2

Chaque service a été déployé sur une instance EC2 via des scripts d’automatisation :

| Service     | AMI             | Script utilisé     | Groupe de sécurité         |
|-------------|------------------|---------------------|-----------------------------|
| MySQL       | Amazon Linux 2023 | `mysql.sh`          | `vprofile-backend-sg`       |
| Memcached   | Amazon Linux 2023 | `memcache.sh`       | `vprofile-backend-sg`       |
| RabbitMQ    | Amazon Linux 2023 | `rabbitmq.sh`       | `vprofile-backend-sg`       |
| Tomcat      | Ubuntu Server (LTS) | `tomcat.sh`      | `vprofile-app-sg`           |
