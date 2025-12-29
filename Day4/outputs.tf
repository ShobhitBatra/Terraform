output "account_alias" {
  value = data.aws_iam_account_alias.current.account_alias
}
output "console_password_iam_user_1" {
  value = aws_iam_user_login_profile.console_access_iam_user_1.password
  sensitive = true
}

output "console_password_iam_user_2" {
  value = aws_iam_user_login_profile.console_access_iam_user_2.password
  sensitive = true
}

output "access_key_id_iam_user_1" {
  value = aws_iam_access_key.access_key_iam_user_1.id
}

output "access_key_secret_iam_user_1" {
  value = aws_iam_access_key.access_key_iam_user_1.secret
  sensitive = true
}

output "access_key_id_iam_user_2" {
  value = aws_iam_access_key.access_key_iam_user_2.id
}

output "access_key_secret_iam_user_2" {
  value = aws_iam_access_key.access_key_iam_user_2.secret
  sensitive = true
}