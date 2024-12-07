#!/bin/bash

# Construction de l'image Pare-feu
docker build -t conteneurparefeuimage:v1.0.0 -f ../ContainerFirewallFile .
echo "Création de l’image Docker du pare-feu..."

# Lancement du conteneur Pare-feu
docker run -d --cap-add=NET_ADMIN --name ContainerPareFeu --network bridge1 --ip 192.168.0.2 conteneurparefeuimage:v1.0.0 sleep infinity
echo "Déploiement du conteneur Firewall..."

# Connexion au deuxième réseau
docker network connect bridge2 --ip 10.0.0.2 ContainerPareFeu
echo "Connexion du conteneur Firewall à bridge2..."

# Configuration interne du Pare-feu
docker exec ContainerPareFeu bash -c "
    echo 1 > /proc/sys/net/ipv4/ip_forward &&
    iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -d 10.0.0.0/24 -j MASQUERADE &&
    iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -d 192.168.0.0/24 -j MASQUERADE
"
echo "Configuration des règles de redirection IP et NAT à l’intérieur du pare-feu..."
