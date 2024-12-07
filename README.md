# Mise en place d'un Environnement de Pré-production avec Docker

## Contexte du Projet
Ce projet consiste à créer un environnement de pré-production pour le déploiement d'une application web dans un environnement Docker. L’infrastructure repose sur plusieurs conteneurs Docker connectés via des réseaux ponts (« bridges »), avec un conteneur jouant le rôle de pare-feu pour contrôler la communication entre les réseaux.

---

## Architecture
![Architecture](images/Architecture_docker.jpg)

---

## Étapes de la Mise en Place

### **1. Création des réseaux ponts**

Exécutez le script `bridge.sh`, situé dans le répertoire `bridges`, pour créer deux ponts réseaux :

```bash
cd bridges
./bridge.sh
```

Ce script configure deux réseaux :
- **bridge1** : sous-réseau `192.168.0.0/24`
- **bridge2** : sous-réseau `10.0.0.0/24`

---

### **2. Déploiement du Conteneur Client**

Le conteneur client est connecté au réseau `bridge1` avec une adresse IP statique `192.168.0.3`.

#### Instructions :
1. Téléchargez le fichier `ContainerClientFile`, contenant le Dockerfile pour le conteneur client.
2. Exécutez le script `deploy_client.sh`, situé dans le répertoire `scripts` :

```bash
cd scripts
./deploy_client.sh
```

---

### **3. Déploiement du Conteneur Pare-feu**

Le conteneur Pare-feu connecte les réseaux `bridge1` et `bridge2`, jouant un rôle de passerelle et de gestionnaire de trafic.

#### Instructions :
1. Téléchargez le fichier `ContainerFirewallFile`, contenant le Dockerfile pour le pare-feu.
2. Exécutez le script `deploy_firewall.sh`, situé dans le répertoire `scripts` :

```bash
cd scripts
./deploy_firewall.sh
```

#### Configuration du routage dans le conteneur Pare-feu :
1. Accédez à l’intérieur du conteneur :
   ```bash
   docker exec -it ContainerPareFeu bash
   ```
2. Activez le routage IP :
   ```bash
   echo 1 > /proc/sys/net/ipv4/ip_forward
   ```
3. Modifiez le fichier de configuration système pour rendre le routage permanent :
   ```bash
   nano /etc/sysctl.conf
   ```
   - **Décommenter ou ajouter la ligne suivante :**
     ```text
     net.ipv4.ip_forward = 1
     ```
4. Configurez les règles NAT pour permettre la communication entre les réseaux :
   ```bash
   iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -d 10.0.0.0/24 -j MASQUERADE
   iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -d 192.168.0.0/24 -j MASQUERADE
   ```

---

### **4. Déploiement du Conteneur Serveur**

Le conteneur serveur est connecté au réseau `bridge2` avec une adresse IP statique `10.0.0.3`.

#### Instructions :
1. Téléchargez le fichier `ContainerServerFile`, contenant le Dockerfile pour le conteneur serveur.
2. Exécutez le script `deploy_server.sh`, situé dans le répertoire `scripts` :

```bash
cd scripts
./deploy_server.sh
```

---

## Résumé des Réseaux

- **bridge1** : Utilisé pour le conteneur client et une interface du pare-feu.
- **bridge2** : Utilisé pour le conteneur serveur et une interface du pare-feu.
- **Pare-feu** : Connecte les deux réseaux et assure la traduction d’adresses (NAT).

---

## Auteur
[Diakite Mamady](https://github.com/DMamady)

---

Avec cette configuration, vous disposez d’un environnement de pré-production fonctionnel, isolé et sécurisé, préparé pour tester des applications web avec Docker.
