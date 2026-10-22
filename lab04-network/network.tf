resource "docker_network" "hub" {
  name = "net-hub"
  ipam_config {
    subnet  = "172.20.0.0/24"
    gateway = "172.20.0.1"
  }
}

resource "docker_network" "spoke" {
  name = "net-spoke"
  ipam_config {
    subnet  = "172.21.0.0/24"
    gateway = "172.21.0.1"
  }
}