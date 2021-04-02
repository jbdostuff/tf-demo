## Creates MySQL instances using RDS

resource "aws_db_subnet_group" "db_subnet_group" {
    name = "rds_subnet"
    subnet_ids = [ "${aws_subnet.private_subnet_aza.id}", "${aws_subnet.private_subnet_azb.id}" ]	

    tags {
        Name         = "Sonar RDS cluster"
        VPC          = "sonar_vpc"
        ManagedBy    = "terraform"
        Environment  = "sonar_rds_cluster"
    }
}

resource "aws_rds_cluster" "rds_cluster" {
    cluster_identifier            = "sonar"
    database_name                 = "sonar"
    master_username               = "${var.rds_master_username}"
    master_password               = "${var.rds_master_password}"
    backup_retention_period       = 14
    preferred_backup_window       = "00:00-01:00"
    preferred_maintenance_window  = "sun:07:00-sun:08:00"
    db_subnet_group_name          = "${aws_db_subnet_group.db_subnet_group.name}"
    skip_final_snapshot           = "true"
    final_snapshot_identifier     = "sonar"
    vpc_security_group_ids        = [
        "${aws_security_group.db.id}"
    ]

    tags {
        Name         = "sonar_rds_cluster"
        VPC          = "sonar_vpc"
        ManagedBy    = "terraform"
        Environment  = "sonar_rds_cluster"
    }

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_rds_cluster_instance" "rds_cluster_instance" {

    count                 = 2
    identifier            = "sonar-rds-instance-${count.index}"
    cluster_identifier    = "${aws_rds_cluster.rds_cluster.id}"
    instance_class        = "db.t2.small"
    db_subnet_group_name  = "${aws_db_subnet_group.db_subnet_group.name}"
    publicly_accessible   = true

    tags {
        Name         = "sonar_rds_cluster-DB-${count.index}"
        VPC          = "sonar_vpc"
        ManagedBy    = "terraform"
        Environment  = "sonar_rds_cluster"
    }

    lifecycle {
        create_before_destroy = true
    }

}

## output
output "cluster_address" {
    value = "${aws_rds_cluster.rds_cluster.endpoint}"
}