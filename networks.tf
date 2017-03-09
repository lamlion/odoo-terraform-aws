resource "aws_vpc" "3tier" {
    cidr_block = "192.168.128.0/22"
    instance_tenancy = "default"
    enable_dns_support = "true" /* This is the default value */
    enable_dns_hostnames = "true" /* Default value is false */
	tags{
    		Name = "3tier-vpc" 
	}
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "igw3tier" {
  vpc_id = "${aws_vpc.3tier.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.3tier.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw3tier.id}"
}


resource "aws_subnet" "tier12a" {
    vpc_id = "${aws_vpc.3tier.id}"
    cidr_block = "192.168.128.0/26"
    availability_zone = "eu-central-1a"
    map_public_ip_on_launch = "true" 

    tags {
        Name = "tier12a-subnet-odoo"
    }
}

resource "aws_subnet" "tier12b" {
    vpc_id = "${aws_vpc.3tier.id}"
    cidr_block = "192.168.128.64/26"
    availability_zone = "eu-central-1b"
    map_public_ip_on_launch = "true" 

    tags {
        Name = "tier12b-subnet-odoo"
    }
}
