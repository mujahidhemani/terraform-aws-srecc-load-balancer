variable "subnet_ids" {
  type        = "list"
  description = "A list of frontend subnets to associate to the internet facing side of the load balancer"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "autoscaling_group_name" {
  description = "The autoscaling group name to attach the load balancer target group to"
}

variable "backend_app_sg_id" {
  description = "The security group ID of the app"
}

variable "tls_cert_arn" {
  description = "The ARN of the TLS certificate to attach to the load balancer listeners"
}