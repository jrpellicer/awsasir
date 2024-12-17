---
layout: page
title: Creación de MV
nav_order: 1
---

# Creación de una Máquina Virtual

## Objetivo del Proyecto

En esta práctica vamos a crear en la nube una máquina virtual de Windows Server 2025 y nos conectaremos a ella por RDP. Conoceremos los recursos de AWS asociados a la creación de esa máquina virtual:

- La instancia EC2 (la propia máquina virtual).
- El volumen EBS asociado (el disco duro de la máquina virtual).
- La red (VPC) y la subred virtual a la que está conectada la máquina.
- Un Internet Gateway (puerta de enlace) para salir a Internet desde la red virtual.
- Una dirección IP pública para conectarnos desde el exterior.
- Una dirección IP Elástica (la IP pública, pero estática, para que no cambie al reiniciar la máquina).
- Un grupo de seguridad para controlar los accesos.


## Esquema en AWS

<img src="./images/EC2.drawio.png">


## Práctica a Realizar

1.- Vamos a crear directamente una máquina en la red virtual (VPC) creada por defecto. Para ello accedemos directamente al servicio de máquinas virtuales de AWS llamado EC2 (Amazon Elastic Compute Cloud).

- Buscamos el servicio **EC2** en la consola.
- Accedemos y pulsamos sobre **Lanzar la Instancia**.

!!! note "Nota"
    
    Tenemos una red creada de manera predeterminada con una dirección de red **172.31.0.0/16**, la cual tiene 6 subredes ubicadas en 6 zonas de disponibilidad distintas de la región en la que se lanza el laboratorio (Norte de Virginia: *us-east-1*). Vamos a crear la máquina en esta red por defecto.

___


2.- Para lanzar la instancia EC2 es necesario asignarle una serie de parámetros obligatorios y configurar otros opcionales.

- El nombre del equipo será *W2025*
- Seleccionamos una imagen (AMI) de *Microsoft Windows Server 2025 Base*.
- En el tamaño de la máquina seleccionamos un tipo de instancia *t3.medium* (2 CPUS y 4 GiB de RAM)
- En el par de claves podemos elegir entre crear un nuevo par de claves o utilizar las ya creadas de nuestro laboratorio (*vockey*). Seleccionamos las ya creadas *vockey*.
- En la configuración de red pulsamos en Editar:
    - Dejamos la VPC (la red virtual) predeterminada.
    - Seleccionamos una subred (por ejemplo la asociada a la zona de disponibilidad 2 cuyo nombre es *us-east-1b* y su dirección de red es *172.13.16.0/20*)
    - Habilitamos la asignación de una IP Pública para conectarnos desde Internet a esta máquina.
    - Creamos un grupo de seguridad (reglas de firewall) nuevo y lo llamamos *acceso-remoto* y le ponemos una descripción (*acceso remoto a W2025*)
    - Como regla de entrada dejamos la que viene por defecto que habilita el *puerto 3389 (RDP)* desde *cualquier lugar* de Internet (0.0.0.0/0)
- Dejamos las opciones de almacenamiento que nos propone por defecto: 30GiB en un disco *SSD de uso general*.
- Lanzamos la instancia.

___


Tras unos minutos se nos crea la instancia, y con ella los siguientes recursos que podemos comprobar.

3.- Accede al panel principal de EC2.

<img src="./images/creacion_MV_01.jpg">


Comprueba pinchando sobre el enlace correspondiente que se ha creado:

- Una **instancia** (máquina).
- Un **volumen EBS** (disco duro).
- 2 **Grupos de seguridad** (el que venía por defecto y el que hemos creado llamado *acceso-remoto*).

