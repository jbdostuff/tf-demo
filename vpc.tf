## Define our Terraform provider (AWS) and create VPC with a bit of config

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "sonar_vpc" {
  cidr_block = "${var.vpc_subnet}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "SonarQube Demo VPC"
  }
}