##
# Providers
#
variable "hcloud_token" {
  type = string
}

##
# Services
#
variable "passwd" {
  description = "UNIX password hash for cloud user"
  type = string
}
