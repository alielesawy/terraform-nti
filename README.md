# Terraform AWS Infrastructure

![Terraform](https://img.icons8.com/color/144/000000/terraform.png)      ![AWS](https://img.icons8.com/color/144/000000/amazon-web-services.png)

This project uses Terraform to create and manage AWS infrastructure. The infrastructure is divided into two sub-projects: Day 1 and Day 2, each focusing on different aspects of the AWS setup.

## Labs Overview

- **Day 1**: Basic VPC setup with subnets, internet gateway, NAT gateway, security groups, and EC2 instances.
- **Day 2**: Advanced setup including additional subnets, NAT gateways, route tables, security groups, application load balancer, auto-scaling group, and more.

## Days-Lab

### Day 1

![Daigram](/assetes/day1D.png)

Basic AWS infrastructure setup including:
- VPC
- Subnets
- Internet Gateway
- NAT Gateway
- Security Groups
- EC2 Instances

For detailed information, visit the [Day 1 README](Day1/README.md).

### Day 2

![Daigram](/assetes/day2D.jpg)

Advanced AWS infrastructure setup including:
- Additional Subnets
- NAT Gateways
- Route Tables
- Security Groups
- Application Load Balancer
- Auto-Scaling Group

For detailed information, visit the [Day 2 README](Day2/README.md).

### Day 3

![Diagram](/assetes/day3.png)

Using modules and varaiables to creat this diagram:
- Public Load Balancer
- Public Load Balancer
- Subnets
- Secuirty Groups
- EC2s

For detailed information, visit the [Day 3 README](Day3/terraform-reverse-proxy/README.md).

## Usage

To apply the Terraform configuration and create the infrastructure, navigate to the respective sub-project directory and run the following commands:

```sh
terraform init
terraform apply