# CONFIGURE AWS PROVIDER 
provider "aws" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  alias = "east1"
  region     = "us-east-1"
}

# CREATE VPC
resource "aws_vpc" "vpceast1" {
  provider = aws.east1
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true

  tags = {
    Name = "VPC-East1" 
  }
}

# CREATE SUBNETS
resource "aws_subnet" "publicsubnet1" {
  provider = aws.east1
  vpc_id     = aws_vpc.vpceast1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicsubnet1"
  }
}

resource "aws_subnet" "privatesubnet1" {
  provider = aws.east1
  vpc_id     = aws_vpc.vpceast1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "privatesubnet1"
  }
}

resource "aws_subnet" "publicsubnet2" {
  provider = aws.east1
  vpc_id     = aws_vpc.vpceast1.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicsubnet2"
  }
}

resource "aws_subnet" "privatesubnet2" {
  provider = aws.east1
  vpc_id     = aws_vpc.vpceast1.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name =  "privatesubnet2"
  }
}

# CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "gw" {
  provider = aws.east1
  vpc_id = aws_vpc.vpceast1.id
  tags = {
    Name = "eksig"
  }
}

# CONFIGURE A NAT GATEWAY
resource "aws_eip" "elastic-ip" {
  provider = aws.east1
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  provider = aws.east1
  subnet_id     = aws_subnet.publicsubnet1.id
  allocation_id = aws_eip.elastic-ip.id
}

# CONFIGURE ROUTE TABLES
resource "aws_route_table" "public" {
  provider = aws.east1
  vpc_id = aws_vpc.vpceast1.id
}

resource "aws_route_table" "private" {
  provider = aws.east1
  vpc_id = aws_vpc.vpceast1.id
}

# CONFIGURE ROUTES
resource "aws_route" "private_ngw" {
  provider = aws.east1
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_route" "public_igw" {
  provider = aws.east1
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_1_subnet" {
  provider = aws.east1
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1_subnet" {
  provider = aws.east1
  subnet_id      = aws_subnet.privatesubnet1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_2_subnet" {
  provider = aws.east1
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_2_subnet" {
  provider = aws.east1
  subnet_id      = aws_subnet.privatesubnet2.id
  route_table_id = aws_route_table.private.id
}
