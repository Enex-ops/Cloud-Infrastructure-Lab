resource "aws_iam_user" "terraform_user" {
  name = "gt3-cloud-terraform-user"
  
}

resource "aws_iam_policy_attachment" "terraform_user_attachment" {
  name       = "gt3-cloud-terraform-user-attachment"
  users      = [aws_iam_user.terraform_user.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  
}

resource "aws_iam_access_key" "terraform_user_key" {
  user    = aws_iam_user.terraform_user.name
}

output "terraform_user_access_key_id" {
  value       = aws_iam_access_key.terraform_user_key.id
  description = "Use this Access Key ID for CLI configuration"
  sensitive   = true
}

output "terraform_user_secret_access_key" {
  value       = aws_iam_access_key.terraform_user_key.secret
  description = "Use this Secret Access Key for CLI configuration"
  sensitive   = true
}