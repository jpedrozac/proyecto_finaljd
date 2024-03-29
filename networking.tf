resource "aws_vpc" "finaltf" {
  cidr_block = "10.0.0.0/21"  
  enable_dns_support = true   
  enable_dns_hostnames = true 
  tags = {
    Name = "finaltf"  
  }
}

resource "aws_subnet" "finaltf1" {
  vpc_id     = aws_vpc.finaltf.id  
  cidr_block = "10.0.1.0/24"        
  availability_zone = "us-east-1a"  
  map_public_ip_on_launch = true    
  tags = {
    Name = "MySubnet1" 
  }
}
resource "aws_subnet" "finaltf2" {
  vpc_id     = aws_vpc.finaltf.id  
  cidr_block = "10.0.2.0/24"        
  availability_zone = "us-east-1b"  
  map_public_ip_on_launch = true    
  tags = {
    Name = "MySubnet2" 
  }
}
resource "aws_internet_gateway" "salidatf" {
  vpc_id     = aws_vpc.finaltf.id  
        
  }
 
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.finaltf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.salidatf.id
  }
}
resource "aws_route_table_association" "public_rt1" {
  subnet_id = aws_subnet.finaltf1.id
  route_table_id = aws_route_table.my_route_table.id 
}

resource "aws_route_table_association" "public_rt2" {
  subnet_id = aws_subnet.finaltf2.id
  route_table_id = aws_route_table.my_route_table.id
}
