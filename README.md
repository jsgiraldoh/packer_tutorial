Despliegue de Nginx y Nodejs mediante una imagen generada por Packer
===

**Objetivos**

En esta actividad aprenderás a utilizar Packer con un ejemplo sencillo, pero con una stack (pila) tecnológica muy utilizada. Con esto conseguirás familiarizarte con la herramienta y entenderás el proceso de adaptación de unas instrucciones a automatismos para crear imágenes reutilizables.

**Pautas de elaboración**

Tendrás que crear una template (plantilla) de Packer que te permita generar una imagen con una aplicación con Node.js ya instalada y configurada con Nginx como servidor web. Deberás documentar cómo funciona la template de Packer, cómo se ha ejecutado, y desplegar la instancia y verificar que funciona correctamente.

Esta stack es muy común en aplicaciones con JS. Es parte de la pila conocida como MEAN. El acrónimo significa:

Mongo.
Express.js.
Angular.
Nginx.

En nuestro caso, nos centraremos especialmente en Nginx y Express.js (realmente node.js).

El despliegue deberá realizarse en una nube pública; se recomienda Amazon AWS, pero opcionalmente puedes usar otra nube pública, aunque tendrás que documentarte más a fondo. Asimismo, Ubuntu 20.04 es la opción preferida, y los recursos que proveemos son para esa distribución.

Para realizar la práctica partiremos desde esta guía:

https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-20-04

Desarrollo
===

Como aborde la solución de este requerimiento:

1) El primer paso fue instalar un servidor con ubuntu y desarrollar todos los pasos que brindaba la guía de **digital ocean**. En este instale todos los componentes y comprobe que funcionara.

2) Luego comprendi porque era necesario utilizar el servidor web **Nginx**, lo que sucede es que cuando se ejecuta la aplicación **hello.js**, esta solo corre localmente, no queda expuesta, por este motivo es necesario realizar las configuraciones de **nginx**.

3) Por consiguiente, me dirigi a la página de **Packer** y busque la sección que siempre buscamos para aprender a usar la técnologia que se llama **Get Started**.

4) Ejecute los pasos del siguiente link: https://learn.hashicorp.com/tutorials/packer/aws-get-started-build-image?in=packer/aws-get-started

    En esta guía mencionan que se deben exportar las credenciales de tú cuenta de amazón, para que la cli funcione correctamente.

    ~~~
    export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
    export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
    ~~~

    Y luego te enseñan a inicializar el proyecto, validar si la sintaxis de las instrucciones que escribiste son correctas y construir la imagen con el lenguaje de packer el cual es **HCL**.

    ~~~
    packer init .
    packer validate .
    packer build aws-ubuntu.pkr.hcl
    ~~~



5) Comprobe los pasos anteriormente mencionados en el link del paso 4.

6) Observe como se creo la imagen de amazon, fui a la sección de Amazon EC2 y ejecute una instancia con esta imagen.

7) Luego, busque un repositorio de git que me indicara una versión más actual de la imagen de ubuntu, ya que tener un S.O más actualizado me evitaria errores en la ejecución de los comandos.

    ~~~
    name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    ~~~

8) Posteriormente, busque como provisionar los elementos que yo necesitaba, y me guíe del siguiente link: https://www.packer.io/docs/provisioners/file

9) En este momento empece a probar como se aprovisionaba la shell y después de varios errores y bloc de notas decidí subir el código y versionarlo a git por si tuviera que volver a un punto átras.

    https://github.com/jsgiraldoh/packer_tutorial.git

10) En este momento me consentre en desarrollar el punto de **provisioner** en la sección **build**

    ~~~
    provisioner "shell" {
        inline = [
          "echo 'Ir al directorio de trabajo del usuario' ",
          "cd ~",
          "echo 'Actualizando los paquetes del S.O' ",
          "sudo apt update",
          "echo 'Descargando y ejecutando script para la instalación de node' ",
          "curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -",
          "echo 'Ejecutando el comando para la instalación de node' ",
          "sudo apt-get install -y nodejs",
          "echo 'La versión de node es la siguiente:' ",
          "node -v",
          "echo 'La versión de npm es la siguiente:' ",
          "npm -v",
          "echo 'Descargar archivo js, que va ha ser usado como servicio' ",
          "curl -O https://raw.githubusercontent.com/jsgiraldoh/packer_tutorial/main/hello.js",
          "echo 'A continuación, instalaremos PM2, un administrador de procesos para aplicaciones de Node.js. PM2 permite implementar demonios en aplicaciones para que puedan funcionar en segundo plano como servicios.' ",
          "sudo npm install pm2@latest -g",
          "echo 'Ejecutar la aplicación en segundo plano' ",
          "pm2 start hello.js",
          "echo 'Instalar el servicio de apliaciones nginx' ",
          "sudo apt install nginx -y",
          "echo 'Detener el servicio de apliaciones nginx' ",
          "sudo systemctl stop nginx",
          "echo 'Descargar el archivo de configuración para el servicio de apliaciones nginx' ",
          "curl -O https://raw.githubusercontent.com/jsgiraldoh/packer_tutorial/main/default",
          "echo 'Mover el archivo de configuración al directorio del servicio' ",
          "sudo mv -f default /etc/nginx/sites-available/default",
          "echo 'Leer el archivo de configuración del servicio nginx' ",
          "cat /etc/nginx/sites-available/default",
          "echo 'Iniciar el servicio de apliaciones nginx' ",
          "sudo systemctl start nginx"
        ]
      }
    ~~~

11) Un punto importante que no pude dominar muy bien, fue el de subir un archivo desde mi ordenador hacia la imagen que se esta creando, por este motivo subi los archivos necesarios al repositorio de git y con el comando **curl** los descargaba mientras se iba contruyendo la imagen.

12) Por ultimo luego de construir la imagen y ejecutar la instancia ejecute el comando que permitia levantar la aplicación en background.

    ~~~
    pm2 start hello.js
    ~~~

Capturas
===

<img src="/img/1.png" title="1.png" name="1.png"/><br>

<img src="/img/2.png" title="2.png" name="2.png"/><br>

<img src="/img/3.png" title="3.png" name="3.png"/><br>

<img src="/img/4.png" title="4.png" name="4.png"/><br>

<img src="/img/5.png" title="5.png" name="5.png"/><br>

<img src="/img/6.png" title="6.png" name="6.png"/><br>

<img src="/img/7.png" title="7.png" name="7.png"/><br>

<img src="/img/8.png" title="8.png" name="8.png"/><br>

<img src="/img/9.png" title="9.png" name="9.png"/><br>

<img src="/img/10.png" title="10.png" name="10.png"/><br>

<img src="/img/11.png" title="11.png" name="11.png"/><br>

<img src="/img/12.png" title="12.png" name="12.png"/><br>
