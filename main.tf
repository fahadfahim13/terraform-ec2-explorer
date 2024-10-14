provider "aws" {
  region = "ap-southeast-2"
}

data "aws_iam_role" "ec2_role" {
  name = "ec2_role"
}

locals {
  role_name   = "ec2_role"
  role_exists = try(aws_iam_role.ec2_role.name, null) != null
}

resource "aws_iam_role" "ec2_role" {
  name = local.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:*", "dynamodb:*", "lambda:*"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
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

