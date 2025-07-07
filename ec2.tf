resource "aws_security_group" "ec2_sg" {
  name        = "cv-ec2-sg"
  description = "Allow HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cv-ec2-sg"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

resource "aws_instance" "cv_ec2" {
  ami                    = "ami-0c02fb55956c7d316"  # Amazon Linux 2 - us-east-1
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Hello from EC2!</h1>" > index.html
              python3 -m http.server 80 &
              EOF

  tags = {
    Name = "cv-ec2-instance"
  }
}


output "ec2_public_ip" {
  value = aws_instance.cv_ec2.public_ip
}
