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
  vpc_id = aws_vpc.warren_vpc_1.id

}

resource "aws_subnet" "public" {
  # will create 2 subnets, index = 0 , index = 1,
  count = var.public_subnet_count
  availability_zone = "us-east-1a"
  # 8 bits added to subnet mask, /16 -> /24, increment by subnet mask incriment, 10.0.0.0 > 10.0.0.
  cidr_block = cidrsubnet(var.vpc_cidr, var.subnet_bits,count.index)
  # daddy needs a public ip
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.warren_vpc_1.id
}
resource "aws_subnet" "private" {
  # will create 2 subnets, index = 0 , index = 1,
  count = var.private_subnet_count
  #availability_zone = "us-east-1a"
  availability_zone = element(var.az_zones, count.index)
  # 8 bits added to subnet mask, /16 -> /24, increment by subnet mask incriment, 10.0.0.0 > 10.0.0.
  cidr_block = cidrsubnet(var.vpc_cidr, var.subnet_bits,count.index + var.public_subnet_count)
  vpc_id = aws_vpc.warren_vpc_1.id
}


resource "aws_route_table" "public-rt1" {
  vpc_id = aws_vpc.warren_vpc_1.id
  tags = {
    bird = "word"
    Name = "warren-private-rt"
  }
}

resource "aws_route" "public-rt-1" {
  route_table_id = aws_route_table.public-rt1.id
  # only default route
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig1.id
    
}

resource "aws_route_table_association" "rt-public" {
  count = var.public_subnet_count
  # associate multiple subnets with the route table above for public subnets
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rt1.id
  
}

resource "aws_eip" "main" {
#  domain = "vpc"
}
