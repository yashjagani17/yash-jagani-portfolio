variable "domain_name" {
  description = "Domain name for the static website"
  type = string
}

variable "project_name" {
  description = "Prefix for all the resources in the cluster"
  type = string
}

variable "project_env" {
  description = "Environment for the project (stage/prod)"
  type = string
}

variable "hosted_zone_id" {
  description = "identifier for a container that holds DNS records in Route53"
  type = string
}