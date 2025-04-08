#!/bin/bash
# Inicia iperf3 en modo servidor en VM_REDES_1
docker run --rm -it --network host networkstatic/iperf3 -s -p 9220
