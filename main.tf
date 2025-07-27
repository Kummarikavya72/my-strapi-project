provider "aws" {
  region     = "us-east-2"
 access_key = var.aws_access_key
 secret_key = var.aws_secret_key
}

resource "aws_instance" "strapi_ec2" {
  ami           = "ami-0d1b5a8c13042c939" # Amazon Linux 2 AMI (update if needed)
  instance_type = "t3.medium"
  key_name      = "task4ec2" # Make sure this key exists in AWS

 user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io git curl
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu

              # Pull and run your Docker image
              docker pull kummarikavya/my-strapi-app:latest
              docker run -d -p 1337:1337 kummarikavya/my-strapi-app:latest
              EOF

  tags = {
    Name = "kavyaStrapi-Terraform-Instance"
  }

  # Optional: Open port 1337 for web access
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi_sg_kavya"
  description = "Allow Strapi port 1337"

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
