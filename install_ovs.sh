#!/bin/bash
# Actualiza el sistema e instala OpenVSwitch
sudo apt update
sudo apt install openvswitch-switch -y

# Activa e inicia el servicio de OpenVSwitch
sudo systemctl enable openvswitch-switch
sudo systemctl start openvswitch-switch
