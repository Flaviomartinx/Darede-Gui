output "public_subnet_id" {
  description = "public eks subnet id"
  value       = aws_subnet.eks_subnet_public.id
}

output "private_subnet_id" {
  description = "private eks subnet id"
  value       = aws_subnet.eks_subnet_private.id
}

output "sg_rds_id" {
  description = "sg rds id"
  value       = aws_security_group.sg_db.id
}

output "sg_nodes_id" {
  description = "sg nodes id"
  value       = aws_security_group.sg_nodes.id
}
