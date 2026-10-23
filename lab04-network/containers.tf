resource "docker_image" "alpine" {
  name         = "alpine:3.20"
  keep_locally = true
}

# alpine non include httpd (sta in busybox-extras): per il web server usiamo busybox
resource "docker_image" "busybox" {
  name         = "busybox:1.36"
  keep_locally = true
}

resource "docker_container" "router" {
  name    = "router"
  image   = docker_image.alpine.image_id
  command = ["sleep", "infinity"]

  capabilities {
    add = ["NET_ADMIN"]
  }
  sysctls = {
    "net.ipv4.ip_forward" = "1"
  }

  networks_advanced {
    name         = docker_network.hub.name
    ipv4_address = "172.20.0.2"
  }
  networks_advanced {
    name         = docker_network.spoke.name
    ipv4_address = "172.21.0.2"
  }
}

resource "docker_container" "vm_hub" {
  name    = "vm-hub"
  image   = docker_image.alpine.image_id
  command = ["sh", "-c", "ip route add 172.21.0.0/24 via 172.20.0.2 && sleep infinity"]

  capabilities {
    add = ["NET_ADMIN"]
  }

  networks_advanced {
    name         = docker_network.hub.name
    ipv4_address = "172.20.0.10"
  }

  host {
    host = "vm-spoke"
    ip   = "172.21.0.10"
  }

  depends_on = [docker_container.router]
}

resource "docker_container" "vm_spoke" {
  name    = "vm-spoke"
  image   = docker_image.busybox.image_id
  command = ["sh", "-c", "ip route add 172.20.0.0/24 via 172.21.0.2 && mkdir -p /www && echo 'ciao dalla spoke' > /www/index.html && httpd -f -p 8080 -h /www"]

  capabilities {
    add = ["NET_ADMIN"]
  }

  networks_advanced {
    name         = docker_network.spoke.name
    ipv4_address = "172.21.0.10"
  }

  host {
    host = "vm-hub"
    ip   = "172.20.0.10"
  }
  depends_on = [docker_container.router]
}