# provider.tf
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "profile" {
  description = "to reference specific aws account"
  type        = string
}

# vpc.tf
variable "vpc_cidr" {
  description = "CIDR for main VPC"
  type        = string
}

variable "az_a" {
  type = string
}

variable "az_b" {
  type = string
}

# compute.tf 
variable "ami" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
