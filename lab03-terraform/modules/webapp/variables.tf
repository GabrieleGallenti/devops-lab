# modules/webapp/variables.tf
variable "project" { type = string }
variable "env" { type = string }
variable "instances" { type = map(number) }
variable "image" {
  type    = string
  default = "nginx:1.27-alpine"
}
