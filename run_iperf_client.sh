#!/bin/bash
# Ejecuta iperf3 en modo cliente en VM_REDES_2
docker run --rm -it --network host networkstatic/iperf3 -c 10.1.1.171 -p 9220
