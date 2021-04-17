##
# Backend
#
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

##
# Provider
#
provider "hcloud" {
  token = var.hcloud_token
}

##
# Locals
#
locals {
  fqdn = "codered.cloud.dejonckhee.re"
  cloud_init = templatefile("default.tmpl.yml", {
    ip_address = hcloud_floating_ip.default.ip_address,
    ssh_public_key = file("~/.ssh/code-red.pub"),
    sshd_public_key = file("~/.ssh/code-red-sshd.pub"),
    sshd_private_key = file("~/.ssh/code-red-sshd"),
    fqdn = local.fqdn,
    hostname = "default",
    passwd = var.passwd,
    default_volume = hcloud_volume.default.linux_device,
  })
}

##
# Authentication
#
resource "hcloud_ssh_key" "default" {
  name = "default"
  public_key = file("~/.ssh/code-red.pub")
}

##
# Instances
#
resource "hcloud_server" "default" {
  name = "default"
  location = "hel1"
  image = "debian-10"
  ssh_keys = [hcloud_ssh_key.default.id]
  user_data = local.cloud_init
  backups = false
  firewall_ids = [hcloud_firewall.default.id]

  # Type    vCPU  RAM   Price/h  Price/mo
  # cx11    1     2G    0.005/h   3.01/mo
  # cpx11   2     2G    0.007/h   4.22/mo
  # cx21    2     4G    0.010/h   5.93/mo
  # cpx21   3     4G    0.013/h   8.35/mo
  # cx31    2     8G    0.017/h  10.77/mo
  # cpx31   4     8G    0.024/h  15.00/mo
  # cx41    4    16G    0.031/h  19.24/mo
  # cpx41   8    16G    0.046/h  27.71/mo
  # cx51    8    32G    0.061/h  36.18/mo
  # cpx51   16   32G    0.097/h  60.38/mo
  server_type = "cx11"
}

##
# Volumes
#
resource "hcloud_volume" "default" {
  name = "default"
  location = "hel1"
  size = 10
  format = "ext4"

  lifecycle {
    prevent_destroy = true
  }
}

resource "hcloud_volume_attachment" "default" {
  volume_id = hcloud_volume.default.id
  server_id = hcloud_server.default.id
}

##
# Network
#
resource "hcloud_rdns" "default4" {
  server_id = hcloud_server.default.id
  ip_address = hcloud_server.default.ipv4_address
  dns_ptr = local.fqdn
}

resource "hcloud_rdns" "default6" {
  server_id = hcloud_server.default.id
  ip_address = hcloud_server.default.ipv6_address
  dns_ptr = local.fqdn
}

resource "hcloud_network" "default" {
  name = "default"
  ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "default" {
  network_id = hcloud_network.default.id
  type = "server"
  network_zone = "eu-central"
  ip_range = "10.0.1.0/24"
}

resource "hcloud_server_network" "default" {
  server_id = hcloud_server.default.id
  network_id = hcloud_network.default.id
}

resource "hcloud_floating_ip" "default" {
  name = "default"
  home_location = "hel1"
  type = "ipv4"

  lifecycle {
    prevent_destroy = true
  }
}

resource "hcloud_floating_ip_assignment" "default" {
  floating_ip_id = hcloud_floating_ip.default.id
  server_id = hcloud_server.default.id
}

resource "hcloud_rdns" "floating_default" {
  floating_ip_id = hcloud_floating_ip.default.id
  ip_address = hcloud_floating_ip.default.ip_address
  dns_ptr = local.fqdn
}

##
# Firewall
#
resource "hcloud_firewall" "default" {
  name = "default"

  # Ping
  rule {
    direction = "in"
    protocol = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # SSH
  rule {
    direction = "in"
    protocol = "tcp"
    port = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # HTTP/HTTPS
  rule {
    direction = "in"
    protocol = "tcp"
    port = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "in"
    protocol = "tcp"
    port = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # DNS
  rule {
    direction = "out"
    protocol = "tcp"
    port = "53"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "out"
    protocol = "udp"
    port = "53"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
}
