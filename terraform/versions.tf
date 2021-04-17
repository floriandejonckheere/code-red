terraform {
  required_providers {
    gandi = {
      source = "psychopenguin/gandi"
      version = "2.0.0-rc3"
    }
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
