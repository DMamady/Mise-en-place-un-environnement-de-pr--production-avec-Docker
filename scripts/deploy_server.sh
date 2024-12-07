#!/bin/bash

# Construction de l'image Serveur
docker build -t conteneurserverimage:v1.0.0 -f ../ContainerServerFile .
echo "Construire l’image Docker du serveur..."

# Lancement du conteneur Serveur
docker run -d --cap-add=NET_ADMIN --name ContainerServer --network bridge2 --ip 10.0.0.3 conteneurserverimage:v1.0.0 sleep infinity
echo "Déploiement du conteneur Server..."

# Configuration des routes statiques
docker exec ContainerServer ip route add 192.168.0.0/24 via 10.0.0.2
echo "Ajout d’une route statique pour atteindre le pont 1 via le pare-feu..."
