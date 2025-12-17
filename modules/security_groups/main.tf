resource "aws_security_group" "firewall_sg" {
  name        = "firewall-sg"
  description = "Security group for firewall endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow inbound traffic from TG subnets"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.tg_ipv4_cidrs
    ipv6_cidr_blocks = var.tg_ipv6_cidrs
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
  {
    Name                  = "${var.application}-${var.env}-sg-${var.region}"
    "Resource Type"       = "security-group"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application" = var.application
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}