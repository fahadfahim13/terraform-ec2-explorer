# Terraform AWS EC2 Instance Deployment

This project uses Terraform to deploy an EC2 instance in AWS. Below is a technical overview of the project structure and components.

## Project Structure

- `main.tf`: Contains the main Terraform configuration for creating the EC2 instance.
- `variables.tf`: Defines input variables used in the Terraform configuration.
- `outputs.tf`: Specifies the output values to be displayed after Terraform applies the configuration.
- `terraform.tfvars`: Contains the actual values for the variables defined in `variables.tf`.
- `.terraform.lock.hcl`: Lock file maintaining provider versions.
- `.gitignore`: Specifies intentionally untracked files to ignore.

## Key Components

### Variables (`variables.tf`)

- `aws_access_key`: AWS access key for authentication.
- `aws_secret_key`: AWS secret key for authentication.
- `aws_region`: AWS region for resource deployment (default: "ap-southeast-2").
- `key_name`: Name of the key pair for EC2 instance (default: "ec2-key").
- `ami_id`: AMI ID for the EC2 instance (default: "ami-001f2488b35ca8aad").
- `instance_type`: EC2 instance type (default: "t2.micro").

### Outputs (`outputs.tf`)

The following information about the created EC2 instance is output:
- Instance ID
- Public IP address
- Public DNS name
- Private IP address
- Private DNS name

### Provider

The project uses the AWS provider (version 5.71.0) from HashiCorp.

### EC2 Instance Configuration

- Region: ap-southeast-2 (Sydney)
- AMI: ami-001f2488b35ca8aad
- Instance Type: t2.micro
- Key Pair: ec2-key

## Usage

1. Ensure you have Terraform installed.
2. Configure your AWS credentials.
3. Customize the `terraform.tfvars` file if needed.
4. Run `terraform init` to initialize the working directory.
5. Run `terraform plan` to see the execution plan.
6. Run `terraform apply` to create the resources.

## Security Considerations

- AWS credentials are not stored in version control.
- The `.gitignore` file is configured to exclude sensitive files and Terraform state files.
- Use of variables for sensitive information allows for secure management of credentials.

## Maintenance

Remember to run `terraform destroy` when you're done to avoid unnecessary AWS charges.
