#!/bin/bash

# Démarrer MySQL
service mysql start

# Créer la base de données
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Créer l'utilisateur et lui donner les droits
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Modifier le mot de passe root
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Rafraîchir les privilèges
mysql -e "FLUSH PRIVILEGES;"

# Arrêter MySQL proprement
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

# Lancer MySQL en mode sécurisé
exec mysqld_safe
