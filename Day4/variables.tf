variable "region" {
  type = string
  default = "ap-south-1"
}

variable "profile" {
  type = string
  description = "Used to switch b/w multiple AWS accounts"
}

variable "iam_user_1" {
  type = string
  description = "iam user 1"
}

variable "iam_user_2" {
  type = string
  description = "iam user 2"
}

variable "policy_arn_iam_user_1" {
  type = string
  description = "Giving iam user 1 full EC2 access"
}

variable "policy_arn_iam_user_2" {
  type = string
  description = "Giving iam user 2 full vpc access"
}

variable customer_managed_policy_iam_user_1{
    type = string
}