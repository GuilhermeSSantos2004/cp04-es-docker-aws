resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Acesso HTTP publico e SSH opcional"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Portal HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.ssh_allowed_cidr == null ? [] : [var.ssh_allowed_cidr]

    content {
      description = "SSH restrito ao IP informado"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    description = "Saida para baixar pacotes e a imagem Docker"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}
