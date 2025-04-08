# NFV con Docker y OpenVSwitch: Implementación y Evaluación

Este proyecto final, desarrollado en el curso de Redes de Computadoras de la Universidad de Lima, explora la implementación de servicios NFV (Network Function Virtualization) utilizando contenedores Docker y OpenVSwitch en Oracle Cloud Infrastructure (OCI). La solución despliega dos máquinas virtuales interconectadas mediante túneles GRE y segmentación por VLAN, permitiendo virtualizar funciones de red y evaluar el desempeño de la infraestructura.

---

## Resumen del Proyecto

- **Objetivo:**  
  Implementar una infraestructura NFV que sustituya hardware propietario por soluciones virtualizadas, proporcionando flexibilidad, escalabilidad y eficiencia en la administración de servicios de red.

- **Solución Propuesta:**  
  - Despliegue de dos VMs en OCI (Ubuntu 22.04) con contenedores Docker que simulan funciones de red.
  - Configuración de OpenVSwitch para crear puentes virtuales y establecer túneles GRE entre las VMs.
  - Segmentación del tráfico mediante VLANs.
  - Ejecución de pruebas de conectividad y rendimiento con `ping` e `iperf3` para validar la infraestructura.

- **Tecnologías Utilizadas:**  
  - **Infraestructura:** Oracle Cloud Infrastructure (OCI)  
  - **Sistema Operativo:** Ubuntu 22.04  
  - **Virtualización:** Docker  
  - **Redes Virtuales:** OpenVSwitch (OVS), túneles GRE, VLANs  
  - **Pruebas de Rendimiento:** iperf3

---

## Arquitectura del Proyecto

La arquitectura se basa en dos máquinas virtuales interconectadas mediante túneles GRE y configuradas con OpenVswitch. Cada VM aloja contenedores Docker que representan funciones de red, lo que permite:
- Aislar y segmentar el tráfico mediante VLANs.
- Garantizar una comunicación segura y de baja latencia entre las VMs.

> **Diagrama del Proyecto:**  
> [Proyecto_NFV_DOCKER_OVS_REDES.drawio.png](https://iddbrwwjvdhv.objectstorage.us-ashburn-1.oci.customer-oci.com/n/iddbrwwjvdhv/b/Foto_Diagrama_Redes/o/Proyecto_NFV_DOCKER_OVS_REDES.drawio.png)

---

## Instalación y Despliegue

1. **Configuración de la Infraestructura:**  
   Despliega dos VMs en OCI con Ubuntu 22.04 y configura sus direcciones IP y acceso SSH.

2. **Instalación del Software Requerido:**  
   Ejecuta los siguientes scripts:

   - **install_docker.sh**
     ```bash
     sudo apt update
     sudo apt install docker.io -y
     sudo systemctl enable docker
     sudo systemctl start docker
     ```
     
   - **install_ovs.sh**
     ```bash
     sudo apt update
     sudo apt install openvswitch-switch -y
     sudo systemctl enable openvswitch-switch
     sudo systemctl start openvswitch-switch
     ```

3. **Creación de Contenedores Docker:**  
   Utiliza el script **create_containers.sh** para crear los contenedores:

   - En **VM_REDES_1:**
     ```bash
     sudo docker run -d --name C1 --network none alpine:latest sleep infinity
     sudo docker run -d --name C2 --network none alpine:latest sleep infinity
     ```
     
   - En **VM_REDES_2:**
     ```bash
     sudo docker run -d --name C3 --network none alpine:latest sleep infinity
     sudo docker run -d --name C4 --network none alpine:latest sleep infinity
     ```

4. **Configuración de OpenVSwitch y Túneles GRE:**  
   Ejecuta los scripts de configuración:

   - **ovs_config_vm1.sh** para VM_REDES_1:
     ```bash
     sudo ovs-vsctl add-port br0 gre0-vlan10 -- set interface gre0-vlan10 type=gre options:remote_ip=10.1.1.219 options:key=10
     sudo ovs-vsctl add-port br2 gre0-vlan20 -- set interface gre0-vlan20 type=gre options:remote_ip=10.1.1.219 options:key=20
     sudo ip addr add 192.168.10.1/24 dev br0
     sudo ip addr add 192.168.20.1/24 dev br2
     sudo ovs-docker add-port br0 eth0 C1 --ipaddress=192.168.10.1/24
     sudo ovs-docker add-port br2 eth0 C2 --ipaddress=192.168.20.1/24
     ```
     
   - **ovs_config_vm2.sh** para VM_REDES_2:
     ```bash
     sudo ovs-vsctl add-port br0 gre0-vlan10 -- set interface gre0-vlan10 type=gre options:remote_ip=10.1.1.171 options:key=10
     sudo ovs-vsctl add-port br2 gre0-vlan20 -- set interface gre0-vlan20 type=gre options:remote_ip=10.1.1.171 options:key=20
     sudo ip addr add 192.168.10.2/24 dev br0
     sudo ip addr add 192.168.20.2/24 dev br2
     sudo ovs-docker add-port br0 eth0 C3 --ipaddress=192.168.10.2/24
     sudo ovs-docker add-port br2 eth0 C4 --ipaddress=192.168.20.2/24
     ```

5. **Pruebas de Conectividad y Rendimiento:**  
   - **Pruebas de Conectividad:**  
     Ejecuta el script **test_connectivity.sh**:
     ```bash
     sudo docker exec -it C1 ping -c 4 192.168.10.2
     sudo docker exec -it C2 ping -c 4 192.168.20.2
     sudo docker exec -it C3 ping -c 4 192.168.10.1
     sudo docker exec -it C4 ping -c 4 192.168.20.1
     ```
     
   - **Pruebas de Rendimiento:**  
     - En **VM_REDES_1 (Servidor)**, ejecuta **run_iperf_server.sh**:
       ```bash
       sudo docker run --rm -it --network host networkstatic/iperf3 -s -p 9220
       ```
     - En **VM_REDES_2 (Cliente)**, ejecuta **run_iperf_client.sh**:
       ```bash
       sudo docker run --rm -it --network host networkstatic/iperf3 -c 10.1.1.171 -p 9220
       ```

---

## Código Fuente

El repositorio incluye los siguientes scripts:

- **install_docker.sh** – Instala Docker.
- **install_ovs.sh** – Instala OpenVSwitch.
- **create_containers.sh** – Crea contenedores Docker en las VMs.
- **ovs_config_vm1.sh** – Configura OpenVSwitch y túneles GRE en VM_REDES_1.
- **ovs_config_vm2.sh** – Configura OpenVswitch y túneles GRE en VM_REDES_2.
- **test_connectivity.sh** – Realiza pruebas de conectividad entre contenedores.
- **run_iperf_server.sh** – Inicia iperf3 en modo servidor en VM_REDES_1.
- **run_iperf_client.sh** – Ejecuta iperf3 en modo cliente en VM_REDES_2.

Ejecucion con script:
```bash
chmod +x install_docker.sh install_ovs.sh create_containers.sh ovs_config_vm1.sh ovs_config_vm2.sh test_connectivity.sh run_iperf_server.sh run_iperf_client.sh
```

---

## Equipo de Trabajo

- Enzo Ordoñez Flores
- Piero Anchorena Campero
- José Mendoza Galvez
- Leandro Caramantin Cruz

---

¡Gracias por revisar este repositorio! Si tienes alguna consulta o deseas colaborar, no dudes en contactarme.

