data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_launch_template" "cv_lt" {
  name_prefix   = "cv-template"
  image_id      = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "<h1>Hello from Auto-Scaled EC2!</h1>" > index.html
              python3 -m http.server 80 &
              EOF
  )

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "cv-autoscaled-instance"
    }
  }
}

# Security Group لـ ALB
resource "aws_security_group" "alb_sg" {
  name        = "cv-alb-sg"
  description = "Allow HTTP to ALB"
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
    Name = "cv-alb-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "cv_alb" {
  name               = "cv-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.all.ids

  tags = {
    Name = "cv-alb"
  }
}

resource "aws_lb_target_group" "cv_tg" {
  name     = "cv-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "cv-target-group"
  }
}

resource "aws_lb_listener" "cv_listener" {
  load_balancer_arn = aws_lb.cv_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cv_tg.arn
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "cv_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = data.aws_subnets.all.ids

  launch_template {
    id      = aws_launch_template.cv_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.cv_tg.arn]

  tag {
    key                 = "Name"
    value               = "cv-asg-instance"
    propagate_at_launch = true
  }

  health_check_type         = "ELB"
  health_check_grace_period = 120
}

output "alb_dns_name" {
  value = aws_lb.cv_alb.dns_name
}
