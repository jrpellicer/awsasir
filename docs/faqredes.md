---
layout: page
title: FAQ Redes
---

# FAQ Redes Virtuales

## Virtual Private Cloud

### ¿Qué es una VPC?

Una VPC (Virtual Private Cloud) en AWS es una red virtual privada que te permite aislar y administrar tus recursos en la nube de forma segura y controlada. Es el entorno lógico donde se implementan recursos como instancias de EC2, bases de datos RDS, y otros servicios.

___

### ¿Qué elementos principales tiene una VPC?

1.-	**CIDR Block** (Classless Inter-Domain Routing)

- Es el rango de direcciones IP que define tu red privada. Ejemplo: 10.0.0.0/16.
- Te permite dividir la VPC en subredes.

2.-	**Subredes**

- Divisiones dentro de la VPC que separan la red en diferentes segmentos lógicos.
- Hay dos tipos:
    - Subredes públicas: conectadas a Internet.
    - Subredes privadas: aisladas de Internet, usadas para recursos internos.

3.-	**Internet Gateway** (IGW)

- Permite que las instancias en subredes públicas tengan acceso a Internet.
- Se asocia a una VPC y a las rutas de la tabla de ruteo.

4.-	**NAT Gateway**

- Permite que las instancias en subredes privadas puedan acceder a Internet de forma segura para tareas salientes (como actualizaciones de software).
- Las conexiones entrantes no están permitidas.

5.-	**Tablas de enrutamiento**

- Determinan cómo se enrutan los paquetes de datos dentro de la VPC, entre subredes y hacia fuera de la VPC (Internet o redes privadas).
- Cada subred está asociada a una tabla de enrutamiento.

6.-	**Peering de VPC**

- Permite conectar dos VPCs para que los recursos de una puedan comunicarse con los de la otra.

7.-	**Endpoint de VPC**

- Permite acceder a servicios de AWS como S3 o DynamoDB desde la VPC sin necesidad de usar un Internet Gateway o NAT.

8.-	**Security Groups**

- Actúan como firewalls virtuales para las instancias EC2, controlando el tráfico entrante y saliente.

9.-	**Network ACLs** (Access Control Lists)

- Controlan el tráfico a nivel de subred. Se usan junto con los Security Groups para añadir una capa adicional de seguridad.

10.- **Elastic IP**

- Una dirección IP estática pública que puedes asignar a recursos dentro de tu VPC.

___

### ¿Cuáles son los pasos en la configuración de la VPC?

1.-	Creación de la VPC

- Definir el rango de direcciones IP (CIDR Block) al crear la VPC.

2.-	División en subredes

- Crear subredes públicas y privadas según las necesidades.
- Asociar tablas de enrutamiento a las subredes para definir cómo se enruta el tráfico.

3.-	Configuración de acceso a Internet

- Asociar un Internet Gateway a la VPC para el tráfico de subredes públicas.
- Usar un NAT Gateway para que subredes privadas puedan realizar conexiones salientes.

4.-	Seguridad

- Configurar Security Groups y Network ACLs para controlar el tráfico entrante y saliente.

5.-	Conexión a otros recursos

- Configurar endpoints de VPC para comunicación con servicios de AWS.
- Establecer peering con otras VPCs si se necesita acceso a redes privadas adicionales.

___

### ¿Cómo se conecta una instancia EC2 a Internet?

1.-	Una instancia en una **subred pública** necesita conectarse a Internet:

- Tiene una dirección IP pública asignada.
- La tabla de enrutamiento de su subred tiene una ruta hacia el Internet Gateway.
- El tráfico fluye desde la instancia → tabla de enrutamiento → Internet Gateway → Internet.

2.-	Una instancia en una **subred privada** necesita descargar actualizaciones:

- El tráfico pasa desde la instancia → tabla de enrutamiento (subred privada)→ NAT Gateway (en la subred pública) → tabla de enrutamiento (subred pública) → Internet Gateway → Internet.
- La respuesta regresa a través del NAT Gateway hacia la instancia.

___

## IPs Públicas

### ¿Dónde se asocian las IPs públicas y para qué?

Cuando se crea una VPC en AWS, no se asocia automáticamente una IP pública a toda la VPC, pero dependiendo de cómo se configuren los recursos dentro de la VPC, se pueden asignar direcciones IP públicas de manera automática o manual. Por ejemplo a Instancias EC2, o NAT Gateways.

___

### ¿Para qué sirve una IP Pública en una instancia EC2?

- Permite que la instancia EC2 sea accesible desde Internet.
- Se utiliza cuando necesitas que la instancia actúe como servidor web, aplicación o cualquier servicio que reciba conexiones entrantes desde la red pública.


___

### ¿Cuándo se debe asignar automáticamente una IP pública?

- **Subred pública con asignación automática**

    - Cuando creas una subred pública, puedes habilitar la opción "Auto-assign public IPv4 address".
    - Todas las instancias lanzadas en esa subred obtendrán automáticamente una dirección IP pública.

- **Subred privada sin IP pública**

    - Si lanzas instancias en una subred privada, no obtendrán direcciones IP públicas automáticamente. Necesitarás un NAT Gateway para que las instancias accedan a Internet (solo tráfico saliente).

___

### ¿Qué pasa si no necesito una IP pública?

Si no deseas que una instancia sea accesible desde Internet:

- Colócala en una subred privada.
- Desactiva la opción *"Auto-assign public IP"* al lanzar la instancia.
- Usa un NAT Gateway o Endpoint para el tráfico saliente, si es necesario.

___

### ¿Qué es una Elastic IP?

Es una dirección IP pública estática que puedes asignar manualmente a un recurso, como una instancia EC2 o un NAT Gateway.

- Asegura que la dirección IP pública de tu recurso no cambie aunque la instancia o el NAT Gateway se reinicie.
- Es ideal para casos donde necesitas una dirección IP conocida para dominios o para establecer reglas de firewall externas.

___

### ¿Dónde se asocia una Elastic IP?

Directamente a la instancia EC2 o al NAT Gateway en la configuración de red.

___

## Tablas de enrutamiento

### ¿Qué es una tabla de enrutamiento?

Una tabla de enrutamiento es un componente fundamental en las redes de una VPC de AWS. Define cómo se dirige el tráfico dentro de la VPC y hacia redes externas, como Internet u otras VPC. Básicamente, es un conjunto de reglas que determinan a dónde se envían los paquetes de datos basados en su destino.

___

### ¿Cómo funciona una tabla de enrutamiento?

Cuando una instancia dentro de una subred envía un paquete de datos, el sistema de enrutamiento utiliza la tabla de enrutamiento asociada para determinar a dónde debe dirigirse el tráfico:

-Examina la dirección de destino del paquete.
- Busca una regla en la tabla de enrutamiento que coincida con esa dirección.
- Redirige el tráfico al destino especificado en la regla.

___

### ¿Cómo sería un ejemplo de tabla de entutamiento de una subred privada?


| Destino      | Objetivo       |
| :----------: | :------------: |
| 10.0.0.0 /16 | local          |
| 0.0.0.0 /16  | nat-gateway    |

Interpretación:

- 10.0.0.0/16 -> local:
        Permite que todos los recursos dentro de la VPC con dirección en el rango 10.0.0.0/16 se comuniquen entre sí sin salir de la red privada.
- 0.0.0.0/0 -> NAT-Gateway:
        Redirige el tráfico saliente destinado a Internet al NAT Gateway que se encuentra en la subred pública.
        El NAT Gateway permite que las instancias en la subred privada se comuniquen con Internet sin ser directamente accesibles desde él.

___

### ¿Cómo sería un ejemplo de tabla de entutamiento de la subred pública?


| Destino      | Objetivo        |
| :----------: | :-------------: |
| 10.0.0.0 /16 | local           |
| 0.0.0.0 /16  | Internet-gateway|

Interpretación:

- 10.0.0.0/16 -> local:
        Igual que en la tabla privada, permite la comunicación entre recursos dentro de la VPC sin salir de la red.
- 0.0.0.0/0 -> Internet-Gateway:
        Define que todo el tráfico destinado a Internet (es decir, fuera del rango 10.0.0.0/16) sea redirigido al Internet Gateway.
        Este es el componente clave que convierte esta subred en una subred pública.

___

### ¿Qué tipos de destinos (Targets) son comunes?

- Internet Gateway (IGW): Para tráfico saliente e entrante hacia Internet.
- NAT Gateway: Para permitir que subredes privadas envíen tráfico saliente a Internet.
- VPC Peering Connection: Para comunicarse con otra VPC en AWS.
- VPN Gateway: Para conectar la VPC con redes locales mediante VPN.
- Instance (ENI): Para redirigir tráfico directamente a una instancia específica.

___

## Internet Gateway

### ¿Qué es el Internet Gateway?

El Internet Gateway (IGW) en AWS es un componente de red que permite la comunicación entre tu VPC y el Internet público. Actúa como un puente que enruta el tráfico desde y hacia las instancias en subredes públicas de la VPC.

___

### ¿Cómo funciona el Internet Gateway?

1.- Asociación con la VPC:

- El IGW debe estar asociado a una VPC específica. Una VPC puede tener solo un IGW activo al mismo tiempo.

2.- Rutas de tráfico:

- Para que las instancias puedan comunicarse con Internet, la tabla de enrutamiento de la subred debe tener una ruta explícita que envíe el tráfico a través del IGW:

```
    Destino: 0.0.0.0/0
    Target: igw-xxxxxxxxxx
```

3.- Requisitos de IP pública:

- Las instancias que desees que sean accesibles desde Internet deben:

    - Tener una dirección IP pública (asignada automáticamente o manualmente).
    - Tener un Security Group configurado para permitir el tráfico entrante desde Internet, como el puerto 22 para SSH o 80/443 para HTTP/HTTPS.

4.- Reglas de seguridad:

- El tráfico permitido hacia las instancias también depende de:

    - Security Groups: Controlan qué conexiones entrantes y salientes están permitidas.
    - Network ACLs: Proporcionan control adicional sobre el tráfico a nivel de subred.

___

## NAT Gateway

### ¿Qué es un NAT Gateway y para qué sirve?

Un NAT (Network Address Translation) Gateway actúa como un puente entre las instancias en subredes privadas y el Internet. Su finalidad principal es permitir que las instancias en una subred privada:

1.-	Accedan a Internet de forma segura, por ejemplo, para:

- Descargar actualizaciones de software.
- Enviar datos a servicios externos.

2.-	Mantenerse protegidas contra conexiones entrantes no deseadas desde Internet.

___

### ¿Por qué necesita una IP pública?

- El NAT Gateway traduce las direcciones IP privadas de las instancias en la subred privada a su propia IP pública.
- De esta forma, las solicitudes salientes (hacia Internet) parecen provenir del NAT Gateway y no de las instancias privadas directamente.
- La IP pública asignada al NAT Gateway es necesaria porque:
    - Es la dirección que identifica al NAT Gateway en Internet.
    - Permite que los servidores de Internet respondan a las solicitudes enviadas desde tus instancias privadas.

___

### ¿Cómo funciona el flujo de tráfico con un NAT Gateway?

1.-	Instancia en subred privada genera tráfico saliente:

- Ejemplo: Una instancia necesita descargar una actualización de software desde un servidor en Internet.

2.-	Tráfico pasa por la tabla de enrutamiento:

- La tabla de enrutamiento de la subred privada tiene una regla que redirige el tráfico hacia el NAT Gateway.

3.-	NAT Gateway traduce la dirección IP:

- Cambia la dirección IP privada de origen de la solicitud a su propia dirección IP pública.
- Envía la solicitud al servidor en Internet.

4.-	Respuesta del servidor regresa al NAT Gateway:

- El servidor en Internet responde a la IP pública del NAT Gateway.
- El NAT Gateway traduce la respuesta y la envía de vuelta a la instancia privada correspondiente.

