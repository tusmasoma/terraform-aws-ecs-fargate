variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
}

variable "env" {
  description = "The environment to deploy to"
}

variable "system" {
  description = "The system name"
}

variable "created_by" {
  description = "tag description for resources made by terraform"
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = number
  default     = 2
}

variable "is_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = true
}