# Terraform AWS Infrastructure

This project uses Terraform to create and manage AWS infrastructure. The infrastructure includes a VPC, subnets, NAT gateways, route tables, security groups, an application load balancer, an auto-scaling group, and more.

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
- **Auto Scaling Group**: To manage the number of EC2 instances based on demand.
- **Launch Template**: To define the configuration for the EC2 instances.
- **Key Pair**: To securely access the EC2 instances.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS account with appropriate permissions to create resources.
- AWS CLI configured with your credentials.

## Usage

1. **Clone the repository**:
    ```sh
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Initialize Terraform**:
    ```sh
    terraform init
    ```

3. **Plan the infrastructure**:
    ```sh
    terraform plan
    ```

4. **Apply the configuration**:
    ```sh
    terraform apply
    ```

5. **Destroy the infrastructure** (when no longer needed):
    ```sh
    terraform destroy
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