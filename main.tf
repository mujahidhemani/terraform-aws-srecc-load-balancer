resource "aws_lb" "lb" {
  name_prefix        = "outyet"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb-frontend-sg.id}", "${var.backend_app_sg_id}"]
  subnets            = "${var.subnet_ids}"
}

resource "aws_security_group" "lb-frontend-sg" {
  name        = "lb-frontend-sg"
  description = "Allow inbound traffic to the LB"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP port 80 traffic"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target-group.arn}"
  }

}

resource "aws_lb_target_group" "target-group" {
  port                 = 8080
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "15"
  lifecycle {
    create_before_destroy = true
  }

  health_check {
    enabled  = true
    interval = 10
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = "${var.autoscaling_group_name}"
  alb_target_group_arn   = "${aws_lb_target_group.target-group.arn}"
}
