variable "name_prefix" {
  type    = string
  default = "k8splat"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "github_org" {
  type    = string
  default = "Deonarayankumar"
}

variable "github_repo" {
  type    = string
  default = "devops-e2e-k8s-delivery"
}

variable "public_zone_name" {
  type    = string
  default = "example.com"
}

variable "tags" {
  type = map(string)
  default = {
    project    = "devops-e2e-k8s-delivery"
    period     = "2026-07-2026-08"
    managed_by = "terraform"
  }
}
