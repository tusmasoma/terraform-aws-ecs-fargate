variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "The AWS region to deploy to"
}

variable "env" {
  type        = string
  description = "The environment to deploy to"
}

variable "system" {
  type        = string
  description = "The system name"
}