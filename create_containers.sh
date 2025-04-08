#!/bin/bash
# Script para crear contenedores Docker según la VM

if [ "$1" == "vm1" ]; then
    echo "Creando contenedores en VM_REDES_1..."
    docker run -d --name C1 --network none alpine:latest sleep infinity
    docker run -d --name C2 --network none alpine:latest sleep infinity
elif [ "$1" == "vm2" ]; then
    echo "Creando contenedores en VM_REDES_2..."
    docker run -d --name C3 --network none alpine:latest sleep infinity
    docker run -d --name C4 --network none alpine:latest sleep infinity
else
    echo "Uso: $0 [vm1|vm2]"
fi
