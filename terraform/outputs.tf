output "instance_id" {
  description = "ID da instância EC2."
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "IP público usado nas evidências."
  value       = aws_instance.web.public_ip
}

output "site_url" {
  description = "URL pública do portal."
  value       = "http://${aws_instance.web.public_ip}"
}

output "docker_image" {
  description = "Imagem executada pela EC2."
  value       = var.docker_image
}

output "evidence_summary" {
  description = "Recursos principais que devem aparecer nos prints."
  value = {
    vpc_id             = aws_vpc.main.id
    subnet_id          = aws_subnet.public.id
    internet_gateway   = aws_internet_gateway.main.id
    route_table_id     = aws_route_table.public.id
    security_group_id  = aws_security_group.web.id
    ec2_instance_id    = aws_instance.web.id
    ec2_public_address = aws_instance.web.public_ip
  }
}
