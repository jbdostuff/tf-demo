resource "aws_security_group" "frontend_app" {
  name = "Frontend app tier"
  tags {
        Name = "Internet facing"
  }
  description = "inbound http(s), ssh, icmp restricted to known IPs"
  vpc_id = "${aws_vpc.sonar_vpc.id}"

  ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = "${var.office_subnets}"
  }

  ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
	cidr_blocks = "${var.office_subnets}"
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = "${var.office_subnets}"
  }

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = "${var.office_subnets}"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name = "Database"
  tags {
        Name = "Database tier"
  }
  description = "MySQL (3306) only inbound"
  vpc_id = "${aws_vpc.sonar_vpc.id}"

  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "TCP"
      security_groups = ["${aws_security_group.frontend_app.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}