variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy to"
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

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "load_balancer_target_group_arn" {
  description = "The ARN of the target group for the load balancer"
  type        = string
}