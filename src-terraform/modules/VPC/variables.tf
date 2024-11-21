## AVAILABILITY ZONES
variable "us-east-1a" {
  type    = string
  default = "us-east-1a"
}

variable "us-east-1b" {
  type    = string
  default = "us-east-1b"
}

## VPC EKS AZ1
variable "vpc_eks_az1_name" {
  type    = string
  default = "VPC_EKS_AZ1"
}

variable "vpc_eks_az1_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

## SUBNET EKS PUBLIC/PRIVATE
variable "eks_subnet_public_cidr" {
  type    = string
  default = "192.168.10.0/24"
}

variable "eks_subnet_private_cidr" {
  type    = string
  default = "192.168.20.0/24"
}

variable "eks_subnet_public_name" {
  type    = string
  default = "EKS_SUBNET_PUBLIC"
}

variable "eks_subnet_private_name" {
  type    = string
  default = "EKS_SUBNET_PRIVATE"
}

## IGW EKS
variable "eks_igw_name" {
  type    = string
  default = "IGW_EKS"
}

## NATGW EKS
variable "eks_natgw_name" {
  type    = string
  default = "NATGW_EKS"
}

## EKS ROUTE TABLE
variable "rt_public_eks_name" {
  type    = string
  default = "RT_PUBLIC_EKS"
}

variable "rt_private_eks_name" {
  type    = string
  default = "RT_PRIVATE_EKS"
}

## VPC NODES AZ1
variable "vpc_nodes_az1_name" {
  type    = string
  default = "VPC_NODES_AZ1"
}

variable "vpc_nodes_az1_cidr" {
  type    = string
  default = "172.16.0.0/16"
}

## SUBNET NODES PUBLIC/PRIVATE
variable "nodes_subnet_public_cidr" {
  type    = string
  default = "172.16.10.0/24"
}

variable "nodes_subnet_private_cidr" {
  type    = string
  default = "172.16.20.0/24"
}

variable "nodes_subnet_public_name" {
  type    = string
  default = "NODES_SUBNET_PUBLIC"
}

variable "nodes_subnet_private_name" {
  type    = string
  default = "NODES_SUBNET_PRIVATE"
}

## IGW NODES
variable "nodes_igw_name" {
  type    = string
  default = "IGW_NODES"
}

## NATGW NODES
variable "nodes_natgw_name" {
  type    = string
  default = "NATGW_NODES"
}

## NODES ROUTE TABLE
variable "rt_public_nodes_name" {
  type    = string
  default = "RT_PUBLIC_NODES"
}

variable "rt_private_nodes_name" {
  type    = string
  default = "RT_PRIVATE_NODES"
}

## SG NODES
variable "sg_nodes_name" {
  type    = string
  default = "SG_NODES"
}

variable "sg_nodes_description" {
  type    = string
  default = "Permite HTTP e HTTPs para os nodes do eks"
}

## SG DB
variable "sg_db_name" {
  type    = string
  default = "SG_DB"
}

variable "sg_db_description" {
  type    = string
  default = "Permite Mysql para o rds"
}

## VPC PEERING 
variable "peering_name" {
  type    = string
  default = "PEERING_EKS-NODES"
}
