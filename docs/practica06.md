---
layout: page
title: Aplicaciones Web con BeanStalk
nav_order: 6
---

# Aplicaciones web con Elastic Beanstalk

## Objetivo del Proyecto

En esta práctica vamos a desplegar una aplicación web de manera totalmente gestionada mediante Elastic Beanstalk, un servicio PaaS que nos ofrece AWS para para implementar y escalar aplicaciones y servicios web. Únicamente hemos de encargarnos de subir el código y Elastic Beanstalk administrará de manera automática la implementación, desde el aprovisionamiento de la capacidad, el equilibrio de carga y el escalado automático hasta la supervisión del estado de la aplicación.

AWS Elastic Beanstalk admite aplicaciones web escritas en varios lenguajes y marcos populares. No necesita cambios de código, o muy pocos, para pasar de la máquina de desarrollo a la nube. Las opciones de desarrollo para implementar aplicaciones web son Java, .NET, Node.js, PHP, Ruby, Python, Go y Docker, entre otras.


## Esquema en AWS

<img src="images/BBDD2.drawio.png">

## Práctica a Realizar
1.-	Eliminamos la *VPC predeterminada* y nos aseguramos que no hay ningún recurso creado en anteriores prácticas (grupos de seguridad, NAT Gateway, instancias EC2, bases de datos, ...)

<br>
___

### Creación de la VPC

2.-	Creamos una nueva VPC con la siguientes características:

- Debe tener 2 AZs.
- 2 Subredes públicas, cada una en una AZ.
- No es necesario un *Gateway NAT* ni un *Gateway de S3*

!!! note "Nota"

    Aunque no usemos Multi-AZ, vamos a crear 2 zonas de disponibilidad por si añadimos una base de datos RDS en nuestra aplicación. Como ya sabemos, AWS requiere al menos dos subredes privadas en diferentes AZ para RDS.

<br>
___

### Creación de la aplicación con Elastic Beanstalk

3.-	Accede al servicio **Elastic Beanstalk** y **Crea una aplicación**:

- El entorno será un servidor web.
- Le asignamos un nombre, por ejemplo *WebAsir*
- En el tipo de plataforma sobre la que va a correr nuestra aplicación seleccionamos **PHP**, puesto que será una aplicación web que correrá en ese entorno de programación.
- En el código de la aplicación dejamos de momento la *Aplicación de ejemplo*.
- Necesitamos especificar un Rol de acceso al servicio. Seleccionamos el existente del laboratorio *LabRole*.
- En el par de claves necesario para la máquina sobre la que correrá seleccionamos también el del laboratorio *vockey*.
- En el perfil de instancia de EC2, seleccionamos *LabInstanceProfile*.
- La VPC será la creada en el paso anterior.
- En el apartado subredes de instancia seleccionamos las 2 subredes creadas.
- Los demás campos los dejamos sin marcar (no creamos ninguna BBDD ni asignamos IP Pública)

<br>
___

### Comprobación del funciomaniento

4.-	Una vez lanzado el entorno correctamente y cuando su estado aparezca *Ok*, comprobamos su Dominio y lo abrimos en el navegador (simplemente pibchando encima) para comprobar que todo funciona. Nos debe aparecer una web con el código de ejemplo en la que aparece *Congratulations!*

<img src="images/Beanstalk_1.jpg">

<br>
___

### Carga de nuestro código

Esel momento de cargar un código propio a nuestra aplicación de Beanstalk. Vamos a utilizar en esta práctica un código HTML + PHP que se encuentra en el repositorio [https://github.com/jrpellicer/asirweb](https://github.com/jrpellicer/asirweb)

5.-	Accedemos al repositorio de GitHub y en el botón de `Code` pulsamos sobre **Download ZIP**

!!! warning "Atención"

    Para subir la aplicación a Beanstalk necesitamos un fichero .zip (o un fichero .tar.gz) pero no nos vale el que acabamos de descargar. El descargado contiene una carpeta con los ficheros de la página web en ella, pero Beanstalk necesita que los ficheros estén en la raíz del fichero .zip (sin carpeta).

6.- Una vez descargado el código vamos a descomprimir el archivo para después volver a comprimirlo, pero sin incluir los archivos en ninguna carpeta comprimida.

=== "Windows"

    1. Extrae el ZIP en una carpeta.
    2. Selecciona los archivos dentro de la carpeta extraída.
    3. Haz clic derecho y elige "Enviar a > Carpeta comprimida".

=== "Linux"

    1. Sitúate en la carpeta donde se ha descargado el archivo.
    2. Descomprime el archivo: `unzip asirweb-main.zip`
    3. Sitúate en el directorio creado al descomprimir: `cd asirweb-main`
    4. Vuelve a comprimir seleccionando todos los ficheros: `zip -r ../codigo.zip *`
    5. Nos ha dejado en el directorio padre un fichero llamado *codigo.zip* listo para ser subido.



<br>
___


6.-	Ahora sí creamos una Base de Datos RDS:

- Seleccionamos el método de *creación estándar*.
- Como motor de base de datos elegimos **MySQL**.
- La plantilla sobre la que se va a basar será la *Capa gratuita* (las demás no son aptas para el laboratorio).
- Ponemos un nombre de servidor que debe ser único en nuestra cuenta de AWS.
- Asignamos nombre de usuario administrador y su contraseña.
- Dejamos las opciones por defecto del tamaño de la instancia y el almacenamiento.
- En el apartado **Conectividad**:
    - Indicamos que vamos a conectar nuestra base de datos a una instancia EC2 y la seleccionamos en el desplegable.
    - En el *Grupo de subredes* elegimos la existente que hemos creado en el punto anterior.
    - NO permitimos el *Acceso Público* a nuestra BBDD. 
    - Elegimos como *grupo de seguridad*, el existente por defecto. Nos informa que además se creará un nuevo grupo de seguridad para conectar la instancia EC2 con la RDS.
- Los demás campos los dejamos por defecto.

<br>
___


7.-	Iniciamos sesión desde la máquina ubuntu y comprobamos que podemos conectarnos a la instancia MySQL, indicando la cadena de conexión y el usuario que hemos definido como administrador. En el parámetro host `-h` ponemos el nombre del servidor y en el parámetro de usuario `-u` el nombre del usuario. Para que nos solicite el password indicamos el parámetro `-p`.

`mysql -h database-jrpm.cruqs8qiedha.us-east-1.rds.amazonaws.com -u admin -p`

<br>
___

### Eliminación de los recursos creados

Una vez comprobada la conexión, para finalizar la práctica eliminamos los recursos creados.

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