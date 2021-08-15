resource "aws_vpc" "eks" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = join("-", [var.env, var.vpc_name])
  }
}
///aws Public subnet 1 ///Has association to public route
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = var.public_subnets_cidr1
  availability_zone       = var.az1
  map_public_ip_on_launch = true

    tags = {
    Name = "k2-public-subnet"
  }


}
///aws public subnet ///not have public route

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = var.public_subnets_cidr2
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "k2-public-subnet"
  }
}

////IGW 

resource "aws_internet_gateway" "publicigw" {
    vpc_id = aws_vpc.eks.id
}

////iGW assoscaition with route table creation public route

resource "aws_route_table" "ekspublic" {
    vpc_id = aws_vpc.eks.id
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.publicigw.id
    }
    
    tags = {
        Name = "ekspublic"
    }
}
/////aws subnet route association
resource "aws_route_table_association" "ekspublicsubnet1"{
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.ekspublic.id
}

resource "aws_route_table_association" "ekspublicsubnet2"{
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.ekspublic.id
}
////////////////////////////////////////////////////////////////////////////////////
///////////PRIVATE Subnet
////////////////////////////////////////////////////////////////////////////////////


//eip for NAT
resource "aws_eip" "nat_gateway" {
  vpc = true
}
//NAT for private to public transfer 
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.public_subnet1.id
  tags = {
    "Name" = "DummyNatGateway"
  }
  depends_on = [aws_internet_gateway.publicigw]
}
//Route table for NAT gateway routed to 0.0.0.0 for subnet 1
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.eks.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
        Name = "eksprivate1"
  }
}
//Route table for NAT gateway routed to 0.0.0.0 for subnet 2
resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.eks.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
        Name = "eksprivate2"
  }
}



////aws private subnet 1
resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = var.private_subnets_cidr1
  availability_zone       = var.az1
    tags = {
    Name = "k2-private-subnet"
  }


}

////aws private subnet 2
resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = var.private_subnets_cidr2
  availability_zone       = var.az2
  tags = {
    Name = "k2-private-subnet"
  }

}

resource "aws_route_table_association" "private1" {
  subnet_id = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private2.id
}
