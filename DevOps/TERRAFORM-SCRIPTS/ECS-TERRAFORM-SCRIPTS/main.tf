terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region = var.region
}

resource "aws_key_pair" "yo-systems" {
    key_name = "id_rsa.pub"
    public_key = "${file(var.ssh_pubkey_file)}"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
}

resource "aws_route_table" "external" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }
}

resource "aws_route_table_association" "external-main" {
    subnet_id = "${aws_subnet.main.id}"
    route_table_id = "${aws_route_table.external.id}"
}



resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.availability_zone}"
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group" "load_balancers" {
    name = "load_balancers"
    description = "Allows all traffic"
    vpc_id = "${aws_vpc.main.id}"

   
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

   
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ecs" {
    name = "ecs"
    description = "Allows all traffic"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = ["${aws_security_group.load_balancers.id}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_ecs_cluster" "main" {
    name = "${var.ecs_cluster_name}"
}

resource "aws_autoscaling_group" "ecs-cluster" {
    availability_zones = ["${var.availability_zone}"]
    name = "ECS ${var.ecs_cluster_name}"
    min_size = "${var.autoscale_min}"
    max_size = "${var.autoscale_max}"
    desired_capacity = "${var.autoscale_desired}"
    health_check_type = "EC2"
    launch_configuration = "${aws_launch_configuration.ecs.name}"
    vpc_zone_identifier = ["${aws_subnet.main.id}"]
}

resource "aws_launch_configuration" "ecs" {
    name = "ECS ${var.ecs_cluster_name}"
    image_id = "${lookup(var.amis, var.region)}"
    instance_type = "${var.instance_type}"
    security_groups = ["${aws_security_group.ecs.id}"]
    iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
    # TODO: is there a good way to make the key configurable sanely?
    key_name = "${aws_key_pair.yobored.key_name}"
    associate_public_ip_address = true
    user_data = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs_cluster_name}' > /etc/ecs/ecs.config"
}


resource "aws_iam_role" "ecs_host_role" {
    name = "ecs_host_role"
    assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
    name = "ecs_instance_role_policy"
    policy = "${file("policies/ecs-instance-role-policy.json")}"
    role = "${aws_iam_role.ecs_host_role.id}"
}

resource "aws_iam_role" "ecs_service_role" {
    name = "ecs_service_role"
    assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
    name = "ecs_service_role_policy"
    policy = "${file("policies/ecs-service-role-policy.json")}"
    role = "${aws_iam_role.ecs_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
    name = "ecs-instance-profile"
    path = "/"
    roles = ["${aws_iam_role.ecs_host_role.name}"]
}
