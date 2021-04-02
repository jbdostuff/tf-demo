## subnets and route tables for all four public and private availability zones

## availability zone A (AZA)

resource "aws_subnet" "public_subnet_aza" {
  vpc_id = "${aws_vpc.sonar_vpc.id}"
  cidr_block = "${var.public_subnet_aza}"
  tags {
    Name = "Privates subnet AZB"
  }
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_route_table_association" "public_subnet_aza" {
  subnet_id = "${aws_subnet.public_subnet_aza.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private_subnet_aza" {
  vpc_id = "${aws_vpc.sonar_vpc.id}"
  cidr_block = "${var.private_subnet_aza}"
  tags {
    Name = "Private subnet AZA"
  }
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_route_table_association" "private_subnet_aza" {
  subnet_id = "${aws_subnet.private_subnet_aza.id}"
  route_table_id = "${aws_route_table.private_aza.id}"
}

## availability zone B (AZB)

resource "aws_subnet" "public_subnet_azb" {
  vpc_id = "${aws_vpc.sonar_vpc.id}"
  cidr_block = "${var.public_subnet_azb}"
  tags {
    Name = "Public subnet AZB"
  }
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

resource "aws_route_table_association" "public_subnet_azb" {
  subnet_id = "${aws_subnet.public_subnet_azb.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private_subnet_azb" {
  vpc_id = "${aws_vpc.sonar_vpc.id}"
  cidr_block = "${var.private_subnet_azb}"
  tags {
    Name = "Private subnet AZB"
  }
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

resource "aws_route_table_association" "private_subnet_azb" {
  subnet_id = "${aws_subnet.private_subnet_azb.id}"
  route_table_id = "${aws_route_table.private_azb.id}"
}