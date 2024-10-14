provider "aws" {
  region = var.aws_region
}

# Check if the IAM role exists
data "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  count = 1
}

locals {
  role_exists = length(data.aws_iam_role.ec2_role) > 0
}

resource "aws_iam_role" "ec2_role" {
  count = local.role_exists ? 0 : 1
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = local.role_exists ? data.aws_iam_role.ec2_role[0].id : aws_iam_role.ec2_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "dynamodb:*",
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "lambda:*",
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}   

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = local.role_exists ? data.aws_iam_role.ec2_role[0].name : aws_iam_role.ec2_role[0].name
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = var.key_name

  tags = {
    Name = "terraform-web-iam-role"
  }
}

