# vpc
resource "aws_vpc" "srikanth" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "ksk_vpc"
  }
}
# public subnet
resource "aws_subnet" "srikanth_pub_sn" {
  vpc_id          = aws_vpc.srikanth.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "srikanth_public_subnet"
  }
}

# private subnet
resource "aws_subnet" "srikanth_pvt_sn" {
  vpc_id                  = aws_vpc.srikanth.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "srikanth_private_subnet"
  }
}

# internet gateway
resource "aws_internet_gateway" "srikanth_igw" {
  vpc_id = aws_vpc.srikanth.id
  tags = {
    Name = "srikanth_internet_gateway"
  }
}
# private route table
resource "aws_route_table" "srikanth_pvt_rt" {
  vpc_id = aws_vpc.srikanth.id
  tags = {
    Name = "srikanth_private_route_table"
  }
}
# private route table association
resource "aws_route_table_association" "srikanth_pvt_asc" {
  subnet_id      = aws_subnet.srikanth_pvt_sn.id
  route_table_id = aws_route_table.srikanth_pvt_rt.id
}

# public route table
resource "aws_route_table" "srikanth_pub_rt" {
  vpc_id = aws_vpc.srikanth.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.srikanth_igw.id
  }
  tags = {
    Name = "srikanth_public_route_table"
  }
}
# public route table association
resource "aws_route_table_association" "srikanth_pub_asc" {
  subnet_id      = aws_subnet.srikanth_pub_sn.id
  route_table_id = aws_route_table.srikanth_pub_rt.id
}

# public nacl 
resource "aws_network_acl" "srikanth_pub_nacl" {
  vpc_id     = aws_vpc.srikanth.id
  subnet_ids = [aws_subnet.srikanth_pub_sn.id]

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "srikanth_public_nacl"
  }
}



# private nacl 
resource "aws_network_acl" "srikanth_pvt_nacl" {
  vpc_id     = aws_vpc.srikanth.id
  subnet_ids = [aws_subnet.srikanth_pvt_sn.id]

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "srikanth_pvt_nacl"
  }
}


# public security group
resource "aws_security_group" "srikanth_pub_sg" {
  name        = "srikanth-web"
  description = "ALLOW SSH & HTTP inbound traffic"
  vpc_id      = aws_vpc.srikanth.id

  ingress {
    description = "SSH from www"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }


  ingress {
    description = "HTTP from www"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "srikanth_pub_firewall"
  }
}

# private security group
resource "aws_security_group" "srikanth_pvt_sg" {
  name        = "srikanth-db"
  description = "ALLOW SSH & MYSQL inbound traffic"
  vpc_id      = aws_vpc.srikanth.id

  ingress {
    description = "SSH from vpc"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 22
    to_port     = 22
  }


  ingress {
    description = "MYSQL from vpc"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 3306
    to_port     = 3306
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "srikanth_db_firewall"
  }
}