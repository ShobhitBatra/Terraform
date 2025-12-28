variable "region" {
  type    = string
  default = "ap-south-1"
}

# key-pair
variable "key_name" {
  type        = string
  description = "key name which will be used for ssh"
}

# ec2
variable "instance_type" {
  type    = string
  default = "t2.micro"
}




