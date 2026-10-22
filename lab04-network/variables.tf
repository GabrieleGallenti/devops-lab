# variables.tf
variable "docker_host" {
  type    = string
  default = "npipe:////./pipe/docker_engine"
}