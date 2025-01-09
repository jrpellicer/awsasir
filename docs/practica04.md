---
layout: page
title: Bases de Datos
nav_order: 4
---

# Bases de Datos Gestionadas

## Objetivo del Proyecto

Para trabajar con una BBDD en AWS podemos optar por 2 modelos diferenciados según sean *IaaS* o *PaaS*:

- En el primer caso, en un modelo de **Infraestructura como Servicio**, contrataríamos la máquina virtual, en una red virtual e instalaríamos el SGBD que consideráramos oportuno (MySQL, SQL Server, PostgrsSQL, …). En este modelo gestionaríamos nosotros toda la infraestructura.

- En el caso de optar por un modelo de **Plataforma como Servicio**, contrataríamos directamente el servicio de base de datos, sin preocuparnos por gestionar la infraestructura que hay por debajo (máquina, red, sistema operativo y sistema gestor de base de datos). Es lo que se conoce como un servicio gestionado. Las bases de datos gestionadas son servicios de base de datos en la nube en los que el proveedor se encarga de toda la administración y mantenimiento, desde la instalación y configuración inicial hasta la escalabilidad, seguridad, copias de seguridad y actualizaciones.

AWS ofrece varios servicios gestionados de Bases de Datos. Los más populares son:

- **RDS**: Es una base de datos relacional gestionada basada en MySQL, PostrgreSQL, MariaDB, Oracle, Aurora o Microsoft SQL Server.
- **Amazon Aurora**: Es un SGBD propio de AWS compatible con MySQL y PostgrSQL que ofrece mejores prestaciones que *RDS*.
- **Amazon DynamoDB**: En este caso se trata de una base de datos NoSQL que soporta modelos de datos clave-valor y documentos.
- **Amazon Neptune**: Base de datos de grafos.
- **Amazon Redshift**: Base de datos relacional para almacenes de datos de Big Data.


!!! note "Nota"
    
    En esta práctica, el servicio gestionado de BBDD que vamos a utilizar es **RDS basado en MySQL**, que permite ejecutar bases de datos MySQL. 


## Esquema en AWS

<img src="images/practica_06_01.png" width="600">

## Práctica a Realizar

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


11.- Desde la consola de AWS, **elimina el servidor de BBDD creado para asegurarnos que no dejamos ningún recurso consumiendo crédito**.

!!! warning "Atención"
    Si detenemos un servidor de BBDD (sin eliminarlo), AWS lo iniciará automáticamente a los 7 días (si no lo hemos levantado nosotros de manera manual antes). Esto es peligroso, pues si olvidamos eliminar un recurso de BBDD que no utilizamos, se pondrá en marcha automáticamente a los 7 días de haberlo detenido, con el consiguiente consumo de crédito.

