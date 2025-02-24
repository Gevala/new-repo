# Create the Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnet[*].id

  enable_deletion_protection = false
}

# Create the Target Group (EC2 Instances)
resource "aws_lb_target_group" "app_tg" {
  name     = "feyi-app-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Register EC2 Instances to the Target Group
resource "aws_lb_target_group_attachment" "public_instance_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn #attaching the Amazon Resource Name
  count            = length(var.public_subnet_cidrs)

  target_id = aws_instance.public_instance[count.index].id
}

# Create the Listener (Routes traffic to Target Group)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

