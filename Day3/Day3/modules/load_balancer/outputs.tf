variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_lb_sg_id" {
  description = "Security group ID for the public load balancer"
  type        = string
}

variable "private_lb_sg_id" {
  description = "Security group ID for the private load balancer"
  type        = string
}