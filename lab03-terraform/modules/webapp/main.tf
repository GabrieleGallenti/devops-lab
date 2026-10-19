# modules/webapp/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_network" "app" {
  name = "net-${var.project}-${var.env}"
}

resource "docker_image" "web" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "web" {
  for_each = var.instances

  name  = "${each.key}-${var.project}-${var.env}"
  image = docker_image.web.image_id

  ports {
    internal = 80
    external = each.value
  }

  networks_advanced {
    name = docker_network.app.name
  }
}
