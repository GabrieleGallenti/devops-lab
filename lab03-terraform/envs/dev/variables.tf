# variables.tf
variable "docker_host" {
  type    = string
  default = "npipe:////./pipe/docker_engine"
}
variable "project" { type = string }
variable "env" { type = string }
variable "web_port" { type = number }
