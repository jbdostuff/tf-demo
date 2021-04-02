## Variables used across the collection of Terraform files

variable "region" {
  default = "us-west-2"
}
variable "ami_tbl" {
  type = "map"
  default = {
    us-west-2 = "ami-223f945a"
  }
  description = "Maps the ami we use for the app to our specificed region"
}

variable "rds_master_username" {
  default = "sonar_admin"
  description = "RDS DB master username"
}

variable "rds_master_password" {
  default = "ThisisapassphraseYay!234"
  description = "RDS MySql SA password"
}

variable "vpc_subnet" {
  default = "172.30.0.0/16"
  description = "VPC CIDR Mask"
}

variable "public_subnet_aza" {
  default = "172.30.1.0/24"
  description = "Public facing subnet AZA"
}

variable "public_subnet_azb" {
  default = "172.30.2.0/24"
  description = "Public facing subnet AZB"
}

variable "private_subnet_aza" {
  default     = "172.30.11.0/24"
  description = "Internal private subnet AZA"
}

variable "private_subnet_azb" {
  default     = "172.30.12.0/24"
  description = "Internal private subnet AZB"
}

variable "dns_zone" {
  default = "sonar.internal"
  description = "Route 53 DNS zone"
}

variable office_subnets {
  default = [ "38.140.26.74/32", "209.210.189.44/32", "73.193.60.252/32"  ]
  description = "Networks to restrict access to"
}

variable "aws_access_key" {
  default = ""
  description = "IAM user key"
}

variable "aws_secret_key" {
  default = ""
  description = "IAM user secret key"
}