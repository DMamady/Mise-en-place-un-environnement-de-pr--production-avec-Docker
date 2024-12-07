#!/bin/bash

# Construction de l'image Client
docker build -t conteneurclientimage:v1.0.0 -f ../ContainerClientFile .

# Lancement du conteneur Client
docker run -d --cap-add=NET_ADMIN --name ContainerClient --network bridge1 --ip 192.168.0.3 conteneurclientimage:v1.0.0 sleep infinity

# Configuration des routes statiques
docker exec ContainerClient ip route add 10.0.0/24 via 192.168.0.2
