#!/bin/bash
# Configuración de OpenVswitch y túneles GRE en VM_REDES_2

# Agregar puertos GRE a los bridges br0 y br2
sudo ovs-vsctl add-port br0 gre0-vlan10 -- set interface gre0-vlan10 type=gre options:remote_ip=10.1.1.171 options:key=10
sudo ovs-vsctl add-port br2 gre0-vlan20 -- set interface gre0-vlan20 type=gre options:remote_ip=10.1.1.171 options:key=20

# Asignar direcciones IP a los bridges
sudo ip addr add 192.168.10.2/24 dev br0
sudo ip addr add 192.168.20.2/24 dev br2

# Conectar contenedores al bridge usando ovs-docker
sudo ovs-docker add-port br0 eth0 C3 --ipaddress=192.168.10.2/24
sudo ovs-docker add-port br2 eth0 C4 --ipaddress=192.168.20.2/24
