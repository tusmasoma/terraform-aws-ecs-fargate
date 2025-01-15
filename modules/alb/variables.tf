variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

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

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}