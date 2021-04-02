# Declare the data source
data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.sonar_vpc.id}"
    tags {
        Name = "Terraform managed internet gateway"
    }
}

## Network ACL is open. See security groups. 

resource "aws_network_acl" "all" {
    vpc_id = "${aws_vpc.sonar_vpc.id}"
    egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "Open ACL. See Security Groups."
   }
}

## Public subnets

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.sonar_vpc.id}"
  tags {
      Name = "Public route table"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}

## Private subnet AZA requires a NAT gateway

resource "aws_route_table" "private_aza" {
  vpc_id = "${aws_vpc.sonar_vpc.id}"
  tags {
      Name = "Private route table AZA"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.public_aza.id}"
  }
}

resource "aws_eip" "nat_aza" {
    vpc      = true
}

resource "aws_nat_gateway" "public_aza" {
    allocation_id = "${aws_eip.nat_aza.id}"
    subnet_id     = "${aws_subnet.public_subnet_aza.id}"
    depends_on    = ["aws_internet_gateway.igw"]
}

## Private subnet AZB requires a NAT gateway

resource "aws_route_table" "private_azb" {
  vpc_id = "${aws_vpc.sonar_vpc.id}"
  tags {
      Name = "Private route table AZB"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.public_azb.id}"
  }
}

resource "aws_eip" "nat_azb" {
    vpc      = true
}

resource "aws_nat_gateway" "public_azb" {
    allocation_id = "${aws_eip.nat_azb.id}"
    subnet_id     = "${aws_subnet.public_subnet_azb.id}"
    depends_on    = ["aws_internet_gateway.igw"]
}