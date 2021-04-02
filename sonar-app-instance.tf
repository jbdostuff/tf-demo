resource "aws_instance" "app" {

  depends_on    = [ "aws_rds_cluster.rds_cluster", "aws_route53_record.db", "aws_rds_cluster_instance.rds_cluster_instance" ]

  ami           = "${lookup(var.ami_tbl, var.region)}"
  instance_type = "t2.small"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.public_subnet_aza.id}"
  vpc_security_group_ids = ["${aws_security_group.frontend_app.id}"]
  key_name = ""

  tags {
        Name = "Sonar Qube App"
  }
  user_data = <<HEREDOC
#!/bin/bash

# Set hostname
hostnamectl set-hostname app.sonar

#disable selinux
setenforce 0

#install packages and update everything
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum update -y
yum -y install nginx wget java-1.8.0-openjdk

## REMINDER: MUST EOF after files 

#install SonarQube using yum
wget -O /etc/yum.repos.d/sonar.repo http://downloads.sourceforge.net/project/sonar-pkg/rpm/sonar.repo
yum install -y sonar

# self signed ssl private key for nginx
cat > /etc/ssl/nginx-selfsigned.key <<EOF
${file("files/nginx-selfsigned.key")}
EOF

# self signed ssl cert for nginx
cat > /etc/ssl/nginx-selfsigned.crt <<EOF
${file("files/nginx-selfsigned.crt")}
EOF

# ephermeral diffie hellman key for nginx forward security
cat > /etc/ssl/dhparam.pem <<EOF
${file("files/dhparam.pem")}
EOF

# nginx ssl enabled config
cat > /etc/nginx/nginx.conf <<EOF
${file("files/nginx.conf")}
EOF

#move default sonar properties and use configured one
mv /opt/sonar/conf/sonar.properties /opt/sonar/conf/sonar.properties.old
cat > /opt/sonar/conf/sonar.properties <<EOF
${file("files/sonar.properties")}
EOF

chkconfig nginx on
service nginx start

chkconfig sonar on
service sonar start

HEREDOC

}

## output
output "ip" {
  value = "${aws_instance.app.public_ip}"
}