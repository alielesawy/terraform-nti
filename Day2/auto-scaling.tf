resource "aws_autoscaling_group" "my_asg" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  target_group_arns   = [aws_lb_target_group.my_target_group.arn]
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
    tag {
    key                 = "terraform"
    value               = "my-auto-scaling-group"
    propagate_at_launch = true
  }
  health_check_type         = "EC2"
  health_check_grace_period = 300
}