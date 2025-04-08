#!/bin/bash
# Prueba de conectividad entre contenedores

echo "Probando conectividad desde C1 a contenedor en VM_REDES_2..."
docker exec -it C1 ping -c 4 192.168.10.2

echo "Probando conectividad desde C2 a contenedor en VM_REDES_2..."
docker exec -it C2 ping -c 4 192.168.20.2

echo "Probando conectividad desde C3 a contenedor en VM_REDES_1..."
docker exec -it C3 ping -c 4 192.168.10.1

echo "Probando conectividad desde C4 a contenedor en VM_REDES_1..."
docker exec -it C4 ping -c 4 192.168.20.1
