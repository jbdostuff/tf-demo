## set up DHCP for our VPC and create route 53 DNS records for the DB endpoint and app host

resource "aws_vpc_dhcp_options" "dhcp_service" {
    domain_name = "${var.dns_zone}"
    domain_name_servers = ["AmazonProvidedDNS"]
    tags {
      Name = "DHCP for sonar.internal"
    }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${aws_vpc.sonar_vpc.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.dhcp_service.id}"
}

resource "aws_route53_zone" "root" {
  name = "${var.dns_zone}"
  vpc_id = "${aws_vpc.sonar_vpc.id}"
  comment = "Managed by terraform"
}

resource "aws_route53_record" "db" {
  zone_id = "${aws_route53_zone.root.zone_id}"
  name = "db.${var.dns_zone}"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_rds_cluster.rds_cluster.endpoint}"]

}

resource "aws_route53_record" "app" {
   zone_id = "${aws_route53_zone.root.zone_id}"
   name = "app.${var.dns_zone}"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.app.private_ip}"]
}