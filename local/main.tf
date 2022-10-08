# Configuración básica de una infraestructura local para wordpress con mysql

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.22.0"
    }
  }
}

#############################################

provider "docker" {
}

#############################################
# Imagenés utilizadas de Docker para 

# Images
resource "docker_image" "img-wordpress" {
    name="wordpress:latest"
}
resource "docker_image" "img-mysql" {
    name = "mysql:latest"
}

#############################################
# Red interna para la comunicación de los diferentes contenedores

# Network
resource "docker_network" "wordpress_net" {
    name = "wordpress_net"
}

#############################################
# Contenedores utilizados para la orquestación de la aplicación

# Containers
resource "docker_container" "container-mysql" {
    image = docker_image.img-mysql.image_id
    name = "database"
    restart = "on-failure"
    env = ["MYSQL_DATABASE=wordpress", "MYSQL_USER=user", "MYSQL_PASSWORD=user", "MYSQL_ROOT_PASSWORD=root"]
    network_mode = "wordpress_net"
    mounts {
        type = "volume"
        target = "/var/lib/mysql"
        source = "db_data"
    }
}

resource "docker_container" "container-wordpress" {
    image = docker_image.img-wordpress.image_id
    name = "wordpress"
    restart = "on-failure"
    network_mode = "wordpress_net"
    ports {
        internal = 80
        external = 8000
    }
    env = ["WORDPRESS_DB_HOST=database", "WORDPRESS_DB_USER=user", "WORDPRESS_DB_PASSWORD=user", "WORDPRESS_DB_NAME=wordpress"]
    mounts {
        type = "volume"
        target = "/var/www/html"
        source = "wordpress_site"
    }
}

#############################################
# Volumenes para el almacenamiento de datos

# Volumes
resource "docker_volume" "db_data" {}

resource "docker_volume" "wordpress_site" {}
