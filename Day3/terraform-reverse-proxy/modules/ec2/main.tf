# Public EC2 Instances (Reverse Proxy)
resource "aws_instance" "public" {
  count                  = length(var.public_subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [var.public_sg_id]
  key_name               = var.key_name
  user_data       = <<-EOF
                          #!/bin/bash
                          sudo apt update -y
                          sudo apt install -y nginx
                          sudo cat <<EOT > /etc/nginx/nginx.conf
                          worker_processes  1;
                          events {
                              worker_connections  1024;
                          }
                          http {
                              server {
                                  listen 80;
                                  location / {
                                      proxy_pass http://${var.internal_lb_dns};
                                      proxy_set_header Host \$host;
                                      proxy_set_header X-Real-IP \$remote_addr;
                                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                                      proxy_set_header X-Forwarded-Proto \$scheme;
                                  }
                              }
                          }
                          EOT
                          sudo systemctl start nginx
                          sudo systemctl enable nginx
                          sudo systemctl restart nginx
                          EOF

  tags = {
    Name = "public-ec2-${count.index + 1}"
  }
}

# Private EC2 Instances (Web Server)
resource "aws_instance" "private" {
  count                  = length(var.private_subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
   user_data       = <<-EOF
                          #!/bin/bash
                          # Exit immediately if a command exits with a non-zero status
                          set -e

                          # Update package lists
                          sudo apt-get update -y

                          # Install Apache2
                          sudo apt-get install -y apache2

                          # Start and enable Apache service
                          sudo systemctl start apache2
                          sudo systemctl enable apache2

                          # Create a simple index.html file
                          sudo echo "Hello From $(hostname -f ) " | sudo tee /var/www/html/index.html

                          # Restart Apache to apply changes
                          sudo systemctl restart apache2

                          # Log completion
                          echo "Apache installation and configuration complete" | sudo tee /var/log/user_data.log
                          EOF

  tags = {
    Name = "private-ec2-${count.index + 1}"
  }
  depends_on = [var.nat_gateway_id]
}