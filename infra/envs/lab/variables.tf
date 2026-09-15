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
  default = "production-grade-kubernetes-platform"
}

variable "public_zone_name" {
  type    = string
  default = "example.com"
}

variable "tags" {
  type = map(string)
  default = {
    project    = "production-grade-kubernetes-platform"
    period     = "2026-07-2026-08"
    managed_by = "terraform"
  }
}
