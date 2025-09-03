# Guide d'Évaluation Inception - Fiche de Révision

## 🔍 Préparatifs avant l'évaluation

### 1. Vérification rapide du projet
```bash
cd ~/inception
make fclean
make
docker ps  # Vérifier que les 3 containers tournent
```

### 2. Test d'accès au site
- ✅ https://maeferre.42.fr (doit fonctionner)
- ❌ http://maeferre.42.fr (ne doit PAS fonctionner)

---

## 📋 Déroulement de l'évaluation

### ÉTAPE 1 : Questions théoriques

**Q: Comment fonctionnent Docker et docker-compose ?**
> **Réponse :** Docker crée des conteneurs isolés qui encapsulent une application et ses dépendances. Docker-compose orchestre plusieurs conteneurs ensemble, définit leurs relations et leur configuration via un fichier YAML.

**Q: Différence entre une image Docker avec et sans docker-compose ?**
> **Réponse :** Sans docker-compose, on lance un conteneur isolé avec `docker run`. Avec docker-compose, on peut lancer plusieurs conteneurs connectés entre eux, avec des volumes partagés et des réseaux communs.

**Q: Avantages de Docker vs VMs ?**
> **Réponse :** Docker est plus léger (partage le kernel), plus rapide à démarrer, utilise moins de ressources. Les VMs sont plus isolées mais plus lourdes car chaque VM a son propre OS.

**Q: Pourquoi cette structure de dossiers ?**
> **Réponse :** 
> - `srcs/` : contient toute la configuration (obligatoire)
> - `requirements/` : sépare chaque service
> - Chaque service a son Dockerfile et ses outils
> - Structure claire et maintenable

### ÉTAPE 2 : Vérifications techniques

#### A. Structure du projet
```bash
# Montrer la structure
tree ~/inception
# ou
ls -la ~/inception
ls -la ~/inception/srcs
```

#### B. Vérification des containers
```bash
cd ~/inception
docker ps
docker-compose -f srcs/docker-compose.yml ps
```
**Réponse attendue :** 3 containers (nginx, wordpress, mariadb) avec status "Up"

#### C. Test NGINX (port 443 uniquement)
```bash
# Test HTTPS (doit marcher)
curl -k https://maeferre.42.fr

# Test HTTP (doit échouer)
curl http://maeferre.42.fr  # Connection refused
```

#### D. Vérification SSL/TLS
- Aller sur https://maeferre.42.fr dans le navigateur
- Cliquer sur le cadenas → "Connexion non sécurisée" → "Certificat non valide"
- **Expliquer :** "C'est normal, c'est un certificat auto-signé généré par OpenSSL"

### ÉTAPE 3 : Vérification des Dockerfiles

#### A. Montrer les Dockerfiles
```bash
cat ~/inception/srcs/requirements/nginx/Dockerfile
cat ~/inception/srcs/requirements/wordpress/Dockerfile
cat ~/inception/srcs/requirements/mariadb/Dockerfile
```

**Points à expliquer :**
- ✅ Un Dockerfile par service
- ✅ Basés sur `debian:bullseye` (version stable)
- ✅ Pas de `FROM` external (pas DockerHub)
- ✅ Pas de `tail -f` ou `sleep infinity`

#### B. Vérification des images
```bash
docker images
```
**Expliquer :** Les images ont le nom du service (srcs-nginx, srcs-wordpress, srcs-mariadb)

### ÉTAPE 4 : Vérification du réseau

```bash
docker network ls
docker network inspect srcs_inception_network
```
**Expliquer :** "Docker-compose crée automatiquement un réseau pour que les containers communiquent entre eux par leurs noms (nginx → wordpress → mariadb)"

### ÉTAPE 5 : Vérification NGINX + SSL

#### A. Vérifier le container
```bash
docker-compose -f srcs/docker-compose.yml ps nginx
```

#### B. Test des ports
```bash
# Port 80 fermé
curl http://maeferre.42.fr  # Doit échouer

# Port 443 ouvert
curl -k https://maeferre.42.fr  # Doit marcher
```

#### C. Certificat SSL/TLS
**Dans le navigateur :**
1. Aller sur https://maeferre.42.fr
2. Accepter le certificat non sécurisé
3. **Expliquer :** "TLS v1.2/v1.3, certificat auto-signé valide pour le projet"

### ÉTAPE 6 : Vérification WordPress

#### A. Vérifier le container
```bash
docker-compose -f srcs/docker-compose.yml ps wordpress
cat ~/inception/srcs/requirements/wordpress/Dockerfile | grep -v nginx
```
**Expliquer :** "Pas de NGINX dans le Dockerfile WordPress, c'est séparé"

#### B. Vérifier le volume
```bash
docker volume ls
docker volume inspect srcs_wordpress_data
```
**Montrer :** Le chemin `/home/maeferre/data/wordpress`

#### C. Test utilisateur WordPress
1. Aller sur https://maeferre.42.fr/wp-admin
2. Se connecter avec : `user` / `user123`
3. Ajouter un commentaire sur un article
4. **Expliquer :** "L'utilisateur 'user' a le rôle 'author'"

#### D. Test administrateur
1. Se connecter avec : `maeferre` / `admin123`
2. Aller dans **Pages** → Modifier une page
3. Changer le contenu → **Mettre à jour**
4. Vérifier sur le site que la page a changé
**Expliquer :** "L'admin s'appelle 'maeferre', pas 'admin' (interdit par le sujet)"

### ÉTAPE 7 : Vérification MariaDB

#### A. Vérifier le container
```bash
docker-compose -f srcs/docker-compose.yml ps mariadb
cat ~/inception/srcs/requirements/mariadb/Dockerfile | grep -v nginx
```

#### B. Vérifier le volume
```bash
docker volume inspect srcs_mariadb_data
```
**Montrer :** Le chemin `/home/maeferre/data/mariadb`

#### C. Se connecter à la base de données
```bash
docker exec -it mariadb mysql -u wpuser -p wordpress
```
**Mot de passe :** `wppassword123`

```sql
-- Vérifier que la DB n'est pas vide
SHOW TABLES;
SELECT user_login FROM wp_users;
exit
```

### ÉTAPE 8 : Test de persistance

#### A. Redémarrer la machine virtuelle
```bash
sudo reboot
```

#### B. Après redémarrage
```bash
cd ~/inception
make
# Attendre que tout démarre
docker ps
```

#### C. Vérifier la persistance
1. Aller sur https://maeferre.42.fr
2. Vérifier que les modifications WordPress sont toujours là
3. **Expliquer :** "Les données sont persistées dans les volumes sur l'hôte"

---

## 🚨 Points d'attention

### Erreurs à éviter
- ❌ Ne jamais dire "admin" pour l'utilisateur administrateur
- ❌ Ne pas utiliser le port 80
- ❌ Ne pas oublier de mentionner que les certificats sont auto-signés

### Si quelque chose ne marche pas
```bash
# Commandes de debug
docker logs nginx
docker logs wordpress  
docker logs mariadb
make fclean && make
```

### Phrases clés à retenir
- "Certificat auto-signé généré avec OpenSSL"
- "TLS v1.2/v1.3 configuré"
- "Volumes persistants sur l'hôte"
- "Réseau Docker-compose pour la communication inter-containers"
- "Utilisateur admin s'appelle 'maeferre' pour respecter le sujet"

---

## ✅ Checklist finale

- [ ] 3 containers actifs (nginx, wordpress, mariadb)
- [ ] HTTPS fonctionne, HTTP bloqué
- [ ] WordPress installé et accessible
- [ ] Connexion admin/user fonctionne
- [ ] Base de données accessible et non vide
- [ ] Volumes configurés correctement
- [ ] Pas de services externes (DockerHub, etc.)
- [ ] Structure de fichiers conforme

**Si tous les points sont verts, l'évaluation est réussie ! 🎉**
