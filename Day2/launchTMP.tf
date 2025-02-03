resource "aws_launch_template" "my_launch_template" {
  name_prefix   = "my-launch-template"
  image_id      = data.aws_ami.AmazonLinux2.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name

  # Base64-encode the user_data
  user_data = base64encode(<<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "Hello World from $(hostname -f)" > /var/www/html/index.html
                EOF
  )

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvdf"
    ebs {
      volume_size = 20
      volume_type = "gp2"
      encrypted   = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "my-ec2-instance"
    }
  }
}