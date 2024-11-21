## VPC EKS
resource "aws_vpc" "vpc_eks_az1" {
  cidr_block           = var.vpc_eks_az1_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_eks_az1_name
  }
}

## SUBNET EKS PUBLIC/PRIVATE
resource "aws_subnet" "eks_subnet_public" {
  vpc_id                  = aws_vpc.vpc_eks_az1.id
  cidr_block              = var.eks_subnet_public_cidr
  availability_zone       = var.us-east-1a
  map_public_ip_on_launch = true
  tags = {
    Name = var.eks_subnet_public_name
  }
}

resource "aws_subnet" "eks_subnet_private" {
  vpc_id                  = aws_vpc.vpc_eks_az1.id
  cidr_block              = var.eks_subnet_private_cidr
  availability_zone       = var.us-east-1b
  map_public_ip_on_launch = true
  tags = {
    Name = var.eks_subnet_private_name
  }
}

## IGW EKS
resource "aws_internet_gateway" "igw_eks" {
  vpc_id = aws_vpc.vpc_eks_az1.id

  tags = {
    Name = var.eks_igw_name
  }
}

## NAT GATEWAY EKS
resource "aws_eip" "eip_eks" {}

resource "aws_nat_gateway" "nat_gateway_eks" {
  allocation_id = aws_eip.eip_eks.id
  subnet_id     = aws_subnet.eks_subnet_public.id

  tags = {
    Name = var.eks_natgw_name
  }
}

## VPC EKS ROUTE TABLES
resource "aws_route_table" "public_rt_eks" {
  vpc_id = aws_vpc.vpc_eks_az1.id

  route {
    cidr_block                = aws_vpc.vpc_nodes_az1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.eks_vpc_peering.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_eks.id
  }
  tags = {
    Name = var.rt_public_eks_name
  }
}

resource "aws_route_table" "private_rt_eks" {
  vpc_id = aws_vpc.vpc_eks_az1.id

  route {
    cidr_block                = aws_vpc.vpc_nodes_az1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.eks_vpc_peering.id
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_eks.id
  }

  tags = {
    Name = var.rt_private_eks_name
  }
}

## VPC NODES
resource "aws_vpc" "vpc_nodes_az1" {
  cidr_block           = var.vpc_nodes_az1_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_nodes_az1_name
  }
}

## SUBNET NODES PUBLIC/PRIVATE
resource "aws_subnet" "nodes_subnet_public" {
  vpc_id                  = aws_vpc.vpc_nodes_az1.id
  cidr_block              = var.nodes_subnet_public_cidr
  availability_zone       = var.us-east-1a
  map_public_ip_on_launch = true
  tags = {
    Name = var.nodes_subnet_public_name
  }
}

resource "aws_subnet" "nodes_subnet_private" {
  vpc_id                  = aws_vpc.vpc_nodes_az1.id
  cidr_block              = var.nodes_subnet_private_cidr
  availability_zone       = var.us-east-1b
  map_public_ip_on_launch = true
  tags = {
    Name = var.nodes_subnet_private_name
  }
}

## IGW NODES
resource "aws_internet_gateway" "igw_nodes" {
  vpc_id = aws_vpc.vpc_nodes_az1.id

  tags = {
    Name = var.nodes_igw_name
  }
}

## NAT GATEWAY NODES
resource "aws_eip" "eip_nodes" {}

resource "aws_nat_gateway" "nat_gateway_nodes" {
  allocation_id = aws_eip.eip_nodes.id
  subnet_id     = aws_subnet.nodes_subnet_public.id

  tags = {
    Name = var.nodes_natgw_name
  }
}

## VPC NODES ROUTE TABLES
resource "aws_route_table" "public_rt_nodes" {
  vpc_id = aws_vpc.vpc_nodes_az1.id

  route {
    cidr_block                = aws_vpc.vpc_eks_az1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.eks_vpc_peering.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_nodes.id
  }
  tags = {
    Name = var.rt_public_nodes_name
  }
}

resource "aws_route_table" "private_rt_nodes" {
  vpc_id = aws_vpc.vpc_nodes_az1.id

  route {
    cidr_block                = aws_vpc.vpc_eks_az1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.eks_vpc_peering.id
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_nodes.id
  }

  tags = {
    Name = var.rt_private_nodes_name
  }
}

## SECURITY GROUP NODES 
resource "aws_security_group" "sg_nodes" {
  name        = var.sg_nodes_name
  description = var.sg_nodes_description
  vpc_id      = aws_vpc.vpc_nodes_az1.id
}

resource "aws_vpc_security_group_ingress_rule" "nodes_sg_ingress_http_rule" {
  security_group_id = aws_security_group.sg_nodes.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "nodes_sg_ingress_https_rule" {
  security_group_id = aws_security_group.sg_nodes.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "nodes_sg_egress_all_rule" {
  security_group_id = aws_security_group.sg_nodes.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

## SECURITY GROUP DB 
resource "aws_security_group" "sg_db" {
  name        = var.sg_db_name
  description = var.sg_db_description
  vpc_id      = aws_vpc.vpc_nodes_az1.id
}

resource "aws_vpc_security_group_ingress_rule" "db_sg_ingress_mysql_rule" {
  security_group_id = aws_security_group.sg_db.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "db_sg_egress_all_rule" {
  security_group_id = aws_security_group.sg_db.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

## VPC PEERING WITH THE VPCs
resource "aws_vpc_peering_connection" "eks_vpc_peering" {
  vpc_id      = aws_vpc.vpc_eks_az1.id
  peer_vpc_id = aws_vpc.vpc_nodes_az1.id
  auto_accept = true

  tags = {
    Name = var.peering_name
  }
}
