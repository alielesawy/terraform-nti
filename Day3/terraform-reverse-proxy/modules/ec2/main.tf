# Public EC2 Instances (Reverse Proxy)
resource "aws_instance" "public" {
  count                  = length(var.public_subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [var.public_sg_id]
  key_name               = var.key_name
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1
    # Configure Nginx reverse proxy
    cat <<EOT > /etc/nginx/nginx.conf
    events {
        worker_connections 1024;
    }

    http {
        upstream backend_servers {
            server ${var.internal_lb_dns}:80;
        }

        server {
            listen 80;

            location / {
                proxy_pass http://backend_servers;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
            }

            error_page 502 503 504 /50x.html;
            location = /50x.html {
                root /usr/share/nginx/html;
            }
        }
    }
    EOT

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
  user_data              = <<-EOF
                            #!/bin/bash
                            yum update -y
                            yum install -y httpd
                            systemctl start httpd
                            systemctl enable httpd
                            echo "Hello World from $(hostname -f)" > /var/www/html/index.html
                            EOF
  tags = {
    Name = "private-ec2-${count.index + 1}"
  }
}