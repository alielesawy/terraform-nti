# Day 3: Terraform Reverse Proxy Setup

This project uses Terraform to create and manage AWS infrastructure for a reverse proxy setup. The infrastructure includes a VPC, subnets, NAT gateway, route tables, security groups, load balancers, and EC2 instances.

## Table of Contents

- [Demo] (#demo)
- [Architecture](#architecture)
- [Modules](#modules)
  - [VPC Module](#vpc-module)
  - [Load Balancer Module](#load-balancer-module)
  - [EC2 Module](#ec2-module)
- [Usage](#usage)
- [Outputs](#outputs)

## Demo

![Demo](/assetes/day3.gif)


## Architecture

The architecture of this project includes the following components:

- **VPC**: A Virtual Private Cloud to host all the resources.
- **Subnets**: Public and private subnets spread across two availability zones.
- **Internet Gateway**: To allow internet access to the public subnets.
- **NAT Gateway**: To allow private subnets to access the internet.
- **Route Tables**: To manage routing within the VPC.
- **Security Groups**: To control inbound and outbound traffic to the resources.
- **Application Load Balancer (ALB)**: To distribute incoming traffic across multiple instances.
- **EC2 Instances**: Public instances for the reverse proxy and private instances for backend services.

## Modules

### VPC Module

The VPC module creates the following resources:

- **VPC**: A Virtual Private Cloud with the specified CIDR block.
- **Subnets**: Public and private subnets within the VPC.
- **Internet Gateway**: To allow internet access to the public subnets.
- **NAT Gateway**: To allow private subnets to access the internet.
- **Route Tables**: Public and private route tables to manage routing within the VPC.

#### Variables

- `vpc_cidr`: The CIDR block for the VPC.
- `public_subnets`: List of public subnet CIDR blocks.
- `private_subnets`: List of private subnet CIDR blocks.

#### Outputs

- `vpc_id`: The ID of the VPC.
- `public_subnets`: The IDs of the public subnets.
- `private_subnets`: The IDs of the private subnets.

### Load Balancer Module

The Load Balancer module creates the following resources:

- **Public Load Balancer**: An application load balancer for public access.
- **Private Load Balancer**: An application load balancer for private access.
- **Public Target Group**: A target group for the public load balancer.
- **Private Target Group**: A target group for the private load balancer.
- **Public Listener**: A listener for the public load balancer.
- **Private Listener**: A listener for the private load balancer.
- **Target Group Attachments**: Attachments to associate EC2 instances with the target groups.

#### Variables

- `vpc_id`: The ID of the VPC.
- `public_subnet_ids`: List of public subnet IDs.
- `private_subnet_ids`: List of private subnet IDs.
- `public_lb_sg_id`: Security group ID for the public load balancer.
- `private_lb_sg_id`: Security group ID for the private load balancer.
- `public_ec2`: List of public EC2 instance IDs.
- `private_ec2`: List of private EC2 instance IDs.

#### Outputs

- `public_lb_dns`: The DNS name of the public load balancer.
- `private_lb_dns`: The DNS name of the private load balancer.

### EC2 Module

The EC2 module creates the following resources:

- **Public EC2 Instances**: Instances for the reverse proxy in the public subnets.
- **Private EC2 Instances**: Instances for backend services in the private subnets.

#### Variables

- `vpc_id`: The ID of the VPC.
- `public_subnet_ids`: List of public subnet IDs.
- `private_subnet_ids`: List of private subnet IDs.
- `public_sg_id`: Security group ID for public instances.
- `private_sg_id`: Security group ID for private instances.
- `ami_id`: AMI ID for the instances.
- `instance_type`: Instance type for the instances.
- `key_name`: Key pair name for the instances.
- `internal_lb_dns`: DNS name of the internal load balancer.

## Usage

To apply the Terraform configuration and create the infrastructure, run the following commands:

```sh
cd Day3
terraform init
terraform apply