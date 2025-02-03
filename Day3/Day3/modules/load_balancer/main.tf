# Public Load Balancer
resource "aws_lb" "public" {
  name               = "public-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_lb_sg_id]
  subnets            = var.public_subnet_ids
  tags = {
    Name = "public-lb"
  }
}

# Public Target Group
resource "aws_lb_target_group" "public" {
  name     = "public-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Public Listener
resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public.arn
  }
}

# Private Load Balancer
resource "aws_lb" "private" {
  name               = "private-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.private_lb_sg_id]
  subnets            = var.private_subnet_ids
  tags = {
    Name = "private-lb"
  }
}

# Private Target Group
resource "aws_lb_target_group" "private" {
  name     = "private-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Private Listener
resource "aws_lb_listener" "private" {
  load_balancer_arn = aws_lb.private.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private.arn
  }
}