# modules/webapp/outputs.tf
output "urls" {
  value = { for k, p in var.instances : k => "http://localhost:${p}" }
}
