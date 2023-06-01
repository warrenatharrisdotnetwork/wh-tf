resource "aws_vpc" "warren_vpc_1" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    # below is the default, not required
    instance_tenancy = "default"
    tags = {
      Name = "warren"
      bird = "word"

    }
  
}

resource "aws_internet_gateway" "ig1" {
  vpc_id = aws_vpc.main.id

}

resource "aws_subnet" "public1" {
  count = 2
  availability_zone = "us-east-1a"
  # 8 bits added to subnet mask, /16 -> /24, increment by subnet mask incriment, 10.0.0.0 > 10.0.0.
  cidr_block = cidrsubnet(var.vpc_cidr, var.subnet_bits,0)
  map_public_ip_on_launch = true
  #cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.warren_vpc_1.id
}

resource "aws_subnet" "public2" {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.warren_vpc_1.id
}

resource "aws_subnet" "private1" {
    availability_zone = "us-east-1a"
    cidr_block = "10.0.2.0/24"
}

resource "aws_route_table" "public-rt1" {
  vpc_id = aws_vpc.warren_vpc_1
  tags = {
    bird = "word"
    Name = "warren-private-rt"
  }
  
}

resource "aws_route" "public-rt-1" {
  route_table_id = aws_route_table.public-rt1
  # only default route
  destinationdestination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig1.id
  
}

resource "aws_route_table_association" "rt-public" {
  # associate multiple subnets with the route table above for public subnets
  subnet_id = [aws_subnet.public1.id,aws_subnet.public2]
  route_table_id = aws_route_table.public-rt1.id
}

