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
      "curl -O https://raw.githubusercontent.com/jsgiraldoh/packer_tutorial/main/hello.js"
    ]
  }
}

