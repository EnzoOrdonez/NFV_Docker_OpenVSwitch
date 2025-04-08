#!/bin/bash
# Actualiza el sistema e instala Docker
sudo apt update
sudo apt install docker.io -y

# Activa e inicia el servicio de Docker
sudo systemctl enable docker
sudo systemctl start docker
