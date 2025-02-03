# Terraform AWS Infrastructure

This project uses Terraform to create and manage AWS infrastructure. The infrastructure includes a VPC, subnets, NAT gateways, route tables, security groups, an application load balancer, an auto-scaling group, and more.

![Demo](/assetes/alb.gif)

## Table of Contents

- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Resources](#resources)
- [Outputs](#outputs)

## Architecture

The architecture of this project includes the following components:

- **VPC**: A Virtual Private Cloud to host all the resources.
- **Subnets**: Public and private subnets spread across two availability zones.
- **Internet Gateway**: To allow internet access to the public subnets.
- **NAT Gateways**: To allow private subnets to access the internet.
- **Route Tables**: To manage routing within the VPC.
- **Security Groups**: To control inbound and outbound traffic to the resources.
- **Application Load Balancer (ALB)**: To distribute incoming traffic across multiple instances.

## Prerequisites

- Terraform installed on your local machine.
- AWS CLI configured with appropriate credentials.
- An AWS account with necessary permissions.

## Usage

To apply the Terraform configuration and create the infrastructure, run the following commands:

```sh
terraform init
terraform apply
```

## Resources

The following Terraform files define the infrastructure:

- **vpc.tf**: Defines the VPC.
- **subnets.tf**: Defines the public and private subnets.
- **igw.tf**: Defines the Internet Gateway.
- **nat.tf**: Defines the NAT Gateways.
- **eip.tf**: Defines the Elastic IPs for the NAT Gateways.
- **pri_route_table.tf** and **pri_route_table.1.tf**: Define the private route tables.
- **pub_route_table.tf**: Defines the public route table.
- **sg.tf** and **lb-sg.tf**: Define the security groups.
- **lb.tf**: Defines the Application Load Balancer, target group, and listener.
- **auto-scaling.tf**: Defines the Auto Scaling Group.
- **launchTMP.tf**: Defines the Launch Template.
- **key.tf**: Defines the Key Pair and saves the private key to a file.
- **ami.tf**: Fetches the latest Amazon Linux 2 AMI.

## Outputs

The following outputs are provided:

- **ALB DNS Name**: The DNS name of the Application Load Balancer.
- **Key Pair Name**: The name of the Key Pair.
- **Private Key**: The private key for the Key Pair (sensitive).

## License

This project is licensed under the MIT License. See the LICENSE file for details.