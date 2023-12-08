# CONFIGURE AWS PROVIDER 
provider "aws" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  alias = "east2"
  region     = "us-east-2"
}

# CREATE VPC
resource "aws_vpc" "vpceast2" {
  provider = aws.east2
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true

  tags = {
    Name = "VPC-East2" 
  }
}

# CREATE SUBNETS
resource "aws_subnet" "publicsubnet3" {
  provider = aws.east2
  vpc_id     = aws_vpc.vpceast2.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicsubnet3"
  }
}

resource "aws_subnet" "privatesubnet3" {
  provider = aws.east2
  vpc_id     = aws_vpc.vpceast2.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "privatesubnet3"
  }
}

resource "aws_subnet" "publicsubnet4" {
  provider = aws.east2
  vpc_id     = aws_vpc.vpceast2.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicsubnet4"
  }
}

resource "aws_subnet" "privatesubnet4" {
  provider = aws.east2
  vpc_id     = aws_vpc.vpceast2.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name =  "privatesubnet4"
  }
}

# CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "gw2" {
  provider = aws.east2
  vpc_id = aws_vpc.vpceast2.id
  tags = {
    Name = "eksig"
  }
}

# CONFIGURE A NAT GATEWAY
resource "aws_eip" "elastic-ip2" {
  provider = aws.east2
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw2" {
  provider = aws.east2
  subnet_id     = aws_subnet.publicsubnet3.id
  allocation_id = aws_eip.elastic-ip2.id
}

# CONFIGURE ROUTE TABLES
resource "aws_route_table" "public2" {
  provider = aws.east2
  vpc_id = aws_vpc.vpceast2.id
}

resource "aws_route_table" "private2" {
  provider = aws.east2
  vpc_id = aws_vpc.vpceast2.id
}

# CONFIGURE ROUTES
resource "aws_route" "private_ngw2" {
  provider = aws.east2
  route_table_id         = aws_route_table.private2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw2.id
}

resource "aws_route" "public_igw2" {
  provider = aws.east2
  route_table_id         = aws_route_table.public2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw2.id
}

resource "aws_route_table_association" "public_3_subnet" {
  provider = aws.east2
  subnet_id      = aws_subnet.publicsubnet3.id
  route_table_id = aws_route_table.public2.id
}

resource "aws_route_table_association" "private_3_subnet" {
  provider = aws.east2
  subnet_id      = aws_subnet.privatesubnet3.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_route_table_association" "public_4_subnet" {
  provider = aws.east2
  subnet_id      = aws_subnet.publicsubnet4.id
  route_table_id = aws_route_table.public2.id
}

resource "aws_route_table_association" "private_4_subnet" {
  provider = aws.east2
  subnet_id      = aws_subnet.privatesubnet4.id
  route_table_id = aws_route_table.private2.id
}
