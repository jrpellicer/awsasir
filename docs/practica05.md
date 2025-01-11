---
layout: page
title: Bases de Datos
nav_order: 5
---

# Bases de Datos Gestionadas

## Objetivo del Proyecto

En esta práctica vamos a crear una base de datos RDS similar a la anterior, pero la vamos a ubicar en una subred privada de manera que no sea accesible desde Internet.

En una subred pública de la VPC crearemos una máquina virtual accesible desde Internet y que sí que podrá acceder a la base de datos. Este sería un modelo típico en el que tenemos un servidor (por ejemplo un servidor web) accesible desde Internet que ataca a una base de datos no accesible desde el exterior, aumentando así la seguridad de nuestros datos necesarios para la aplicación web.


## Esquema en AWS

<img src="images/BBDD2.drawio.png">

## Práctica a Realizar
1.-	Eliminamos la VPC por defecto y nos aseguramos que no hay ningún recurso creado en anteriores prácticas (grupos de seguridad, NAT Gateway, instancias EC2, bases de datos, ...)

<br>
___


2.-	Creamos una nueva VPC con dos AZs y con 2 subredes públicas (10.0.1.0/24 y 10.0.2.0/24) y dos privadas (10.0.3.0/24 y 10.0.4.0/24), cada una en una AZ.

!!! note "Nota"

    Aunque no usemos Multi-AZ, AWS requiere al menos dos subredes privadas en diferentes AZ para RDS. Esto mejora la flexibilidad y disponibilidad, aunque la configuración inicial sea simple.

<br>
___


3.-	Creamos una instancia EC2 en la primera subred pública (AMI Ubuntu). En datos usuarios poner la instalación de mysql-client-core-8.0

<br>
___


4.-	Nos conectamos por ssh para comprobar que todo funciona.

<br>
___


5.-	Creamos grupo de subredes con las 2 subredes privadas.

<br>
___


6.-	Creamos una DB RDS.

<br>
___


7.-	Iniciamos sesión desde la máquina ubuntu y comprobamos que podemos conectarnos a la instancia MySQL, indicando la cadena de conexión y el usuario que hemos definido como administrador. En el parámetro host `-h` ponemos el nombre del servidor y en el parámetro de usuario `-u` el nombre del usuario. Para que nos solicite el password indicamos el parámetro `-p`.

`mysql -h database-jrpm.cruqs8qiedha.us-east-1.rds.amazonaws.com -u admin -p`

<br>
___


8.- Desde la consola de AWS, **elimina el servidor de BBDD creado para asegurarnos que no dejamos ningún recurso consumiendo crédito**. No crees ninguna instantánea final ni conserves las copias de seguridad.

!!! warning "Atención"
    Si detenemos un servidor de BBDD (sin eliminarlo), AWS lo iniciará automáticamente a los 7 días (si no lo hemos levantado nosotros de manera manual antes). Esto es peligroso, pues si olvidamos eliminar un recurso de BBDD que no utilizamos, se pondrá en marcha automáticamente a los 7 días de haberlo detenido, con el consiguiente consumo de crédito.


<img src="./images/BBDD_03.png" width=400>

<br>
___

9.- Desde la consola de AWS, **elimina la instancia EC2**. 

<br>
___

10.- Desde la consola de AWS, **elimina la VPC**. 

<br>
___
1.-  Accedemos a la consola, dentro de la categoría Bases de Datos, seleccionamos el recurso **RDS**.

<br>
___


2.-	Creamos una Base de Datos:

- Seleccionamos el método de *creación estándar*.
- Como motor de base de datos elegimos **MySQL**.
- La plantilla sobre la que se va a basar será la *Capa gratuita* (las demás no son aptas para el laboratorio).
-	Ponemos un nombre de servidor que debe ser único en nuestra cuenta de AWS. Introduce uno que lleve tu nombre o iniciales.
-	Asignamos nombre de usuario administrador y su contraseña.
- Dejamos las opciones por defecto del tamaño de la instancia y el almacenamiento.
- No vamos a conectar nuestra BBDD a ninguna instancia EC2, y dejamos la BBDD en la VPC por defecto (*Default VPC*).
-	**Importante**: Permitimos el *Acceso Público* a nuestra BBDD. Esto generará una IP Pública para poder conectarnos desde Internet.
- Creamos un nuevo *grupo de seguridad*, por ejemplo *bbdd-sg*
-	Los demás campos los dejamos por defecto.

<br>

!!! note "Nota"
    
    Podríamos haber seleccionado el **método de creación rápida**, que nos pide muchos menos parámetros para crear la BBDD, pero nos habría dejado la opción de **Permitir Acceso Público** como **NO**. Ello implica que nos tocaría acceder a modificar los parámetros una vez creada la BBDD para permitir ese acceso público, y además deberíamos permitir la regla de entrada correspondiente en el grupo de seguridad.

<br>
___


3.-	Una vez creado el recurso accedemos a él y en el apartado **Conectividad y seguridad** comprobamos el endpoint y el puerto por al cual accederemos. **Copiamos el punto de enlace en el portapapeles.**


Comprobamos también que se nos ha asociado el nuevo grupo de seguridad que hemos creado.

<br>

<img src="./images/BBDD_01.png">
<br>
___

4.-	En el apartado de *Configuración* nos aparecen los datos de la configuración de la máquina virtual sobre la que está corriendo nuestro SGBD, así como la versión de MySQL instalada y el nombre del usuario administrador.

<br>
___

5.-	Volvemos al apartado de *Conectividad y seguridad* y accedemos al grupo de seguridad *bbdd-sg* que se nos ha creado para ver las reglas de firewall que nos ha puesto por defecto. En las reglas de entrada comprobamos que se ha creado la regla para permitir conexiones desde nuestra IP local a la BBDD por el puerto de MySQL (3306).

<br>

<img src="./images/BBDD_02.png">
<br>
___

6.-	En nuestra máquina local establacemos una conexión mediante un cliente de MySQL de línea de comandos, indicando la cadena de conexión y el usuario que hemos definido como administrador. En el parámetro host `-h` ponemos el nombre del servidor (endpoint que hemos copiado en el portapapeles) y en el parámetro de usuario `-u` el nombre del usuario. Para que nos solicite el password indicamos el parámetro `-p`.

`mysql -h database-jrpm.cruqs8qiedha.us-east-1.rds.amazonaws.com -u admin -p`

Una vez comprobada la conexión, cerramos la sesión:

`exit;`

!!! warning "Atención"
    
    Si hemos dejado la opción de **Permitir Acceso Público** como **NO** o no aparece la regla de seguridad del firewall (grupo de seguridad) no podremos conectarnos.

<br>
___

7.- Vamos a crear una base de datos con una tabla. Lo vamos a hacer mediante un script de sentencias sql. Para ello comenzamos con la descarga del fichero de creación de la base de datos.

=== "Linux"

    ```
    wget https://github.com/jrpellicer/proyectoasir/raw/refs/heads/main/asir.sql
    ```

=== "Windows"

    [Descarga fichero sql](./asir.sql)

<br>
___

8.- Ejecutamos el contenido del fichero descargado.

```
mysql -h database-jrpm.cruqs8qiedha.us-east-1.rds.amazonaws.com -u admin -p < asir.sql
```

<br>
___

9.- Comprobamos que se ha ejecutado correctamente y se ha creado la base de datos y la tabla correspondiente.

```bash
mysql -h database-jrpm.cruqs8qiedha.us-east-1.rds.amazonaws.com -u admin -p
```

```sql
use webasir;
select * from clientes;
exit;
```

<br>
___

10.- Podemos establacer conexión remota también mediante clientes GUI como *DBeaver*, *HeidiSQL*, *MySQL Workbench*, ... 

<br>
___


11.- Desde la consola de AWS, **elimina el servidor de BBDD creado para asegurarnos que no dejamos ningún recurso consumiendo crédito**. No crees ninguna instantánea final ni conserves las copias de seguridad.

!!! warning "Atención"
    Si detenemos un servidor de BBDD (sin eliminarlo), AWS lo iniciará automáticamente a los 7 días (si no lo hemos levantado nosotros de manera manual antes). Esto es peligroso, pues si olvidamos eliminar un recurso de BBDD que no utilizamos, se pondrá en marcha automáticamente a los 7 días de haberlo detenido, con el consiguiente consumo de crédito.


<img src="./images/BBDD_03.png" width=400>