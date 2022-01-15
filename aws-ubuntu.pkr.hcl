packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"
  sources = [ "source.amazon-ebs.ubuntu" ]

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
}

