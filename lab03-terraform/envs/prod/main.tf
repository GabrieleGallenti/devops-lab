# envs/dev/main.tf
terraform {
  required_version = ">= 1.9"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

module "webapp" {
  source    = "../../modules/webapp"
  project   = var.project
  env       = var.env
  instances = { site = 9081, api = 9082, admin = 9083 }
}
