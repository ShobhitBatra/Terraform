# Creating 2 IAM users
resource "aws_iam_user" "iam_user_1" {
  name = var.iam_user_1
}

resource "aws_iam_user" "iam_user_2" {
  name = var.iam_user_2
}

# Allowing console access to both users
resource "aws_iam_user_login_profile" "console_access_iam_user_1" {
  user = aws_iam_user.iam_user_1.name
  password_length = 20
  password_reset_required = true
}

resource "aws_iam_user_login_profile" "console_access_iam_user_2" {
  user = aws_iam_user.iam_user_2.name
  password_length = 20
  password_reset_required = true
}

# Creating access keys for both users
resource "aws_iam_access_key" "access_key_iam_user_1" {
  user = aws_iam_user.iam_user_1.name
}

resource "aws_iam_access_key" "access_key_iam_user_2" {
  user = aws_iam_user.iam_user_2.name
}

# AWS managed policy
resource "aws_iam_user_policy_attachment" "policy_iam_user_1" {
  user= aws_iam_user.iam_user_1.name
  policy_arn = var.policy_arn_iam_user_1
}

resource "aws_iam_user_policy_attachment" "policy_iam_user_2" {
  user= aws_iam_user.iam_user_2.name
  policy_arn = var.policy_arn_iam_user_2
}

# Customer Managed policy for iam_user_1 to list buckets and list objects inside bucket (names only)
resource "aws_iam_policy" "customer_managed_policy_iam_user_1" {
   name = var.customer_managed_policy_iam_user_1

   policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:ListBucket"
            ],
            "Resource": "*"
        }
    ]
   })
}

resource "aws_iam_user_policy_attachment" "customer_managed_policy_attachment_iam_user_1" {
  user = aws_iam_user.iam_user_1.name
  policy_arn = aws_iam_policy.customer_managed_policy_iam_user_1.arn
}

# Creating inline policy for iam_user_2 
 resource "aws_iam_user_policy" "inline_policy_iam_user_2" {
   user = aws_iam_user.iam_user_2.name
   policy = jsonencode({ 
     Version="2012-10-17", 
     Statement=[{ 
         Effect="Allow", 
         Action="ec2:*", // means all EC2 actions — create, delete, modify, start, stop, everything related to EC2.
         Resource="*"  // applies to all ec2 instances in the account 
     }] 
   })
 }