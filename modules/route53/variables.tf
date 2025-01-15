variable "env" {
  description = "The environment to deploy to"
  type        = string
}

variable "system" {
  description = "The system name"
  type        = string
}

variable "created_by" {
  description = "Tag description for resources made by terraform"
  type        = string
}

variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  type        = string
}

variable "load_balancer_zone_id" {
  description = "The zone ID of the load balancer"
  type        = string
}
