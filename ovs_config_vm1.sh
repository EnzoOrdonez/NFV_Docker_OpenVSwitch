#!/bin/bash
# Configuración de OpenVSwitch y túneles GRE en VM_REDES_1

# Agregar puertos GRE a los bridges br0 y br2
sudo ovs-vsctl add-port br0 gre0-vlan10 -- set interface gre0-vlan10 type=gre options:remote_ip=10.1.1.219 options:key=10
sudo ovs-vsctl add-port br2 gre0-vlan20 -- set interface gre0-vlan20 type=gre options:remote_ip=10.1.1.219 options:key=20

# Asignar direcciones IP a los bridges
sudo ip addr add 192.168.10.1/24 dev br0
sudo ip addr add 192.168.20.1/24 dev br2

# Conectar contenedores al bridge usando ovs-docker (nota: ovs-docker debe estar instalado/configurado)
sudo ovs-docker add-port br0 eth0 C1 --ipaddress=192.168.10.1/24
sudo ovs-docker add-port br2 eth0 C2 --ipaddress=192.168.20.1/24
