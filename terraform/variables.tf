variable "aws_region" {
  description = "Região AWS liberada pelo ambiente acadêmico."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefixo usado nos nomes e tags dos recursos."
  type        = string
  default     = "cp04-es"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Use apenas letras minúsculas, números e hífens."
  }
}

variable "vpc_cidr" {
  description = "Bloco IPv4 da VPC."
  type        = string
  default     = "10.0.0.0/24"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr deve ser um bloco CIDR IPv4 válido."
  }
}

variable "public_subnet_cidr" {
  description = "Bloco IPv4 da sub-rede pública."
  type        = string
  default     = "10.0.0.0/26"

  validation {
    condition     = can(cidrnetmask(var.public_subnet_cidr))
    error_message = "public_subnet_cidr deve ser um bloco CIDR IPv4 válido."
  }
}

variable "instance_type" {
  description = "Tipo de instância permitido pelo AWS Academy."
  type        = string
  default     = "t2.micro"
}

variable "docker_image" {
  description = "Imagem pública do Docker Hub, obrigatoriamente com a tag cp04."
  type        = string

  validation {
    condition     = endswith(var.docker_image, ":cp04")
    error_message = "A imagem precisa terminar com a tag :cp04."
  }
}

variable "ssh_allowed_cidr" {
  description = "CIDR autorizado para SSH, por exemplo 203.0.113.10/32. Null mantém a porta 22 fechada."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.ssh_allowed_cidr == null || can(cidrnetmask(var.ssh_allowed_cidr))
    error_message = "ssh_allowed_cidr deve ser null ou um bloco CIDR IPv4 válido."
  }
}

variable "key_name" {
  description = "Nome de um key pair já existente na AWS. Null desativa login por chave SSH."
  type        = string
  default     = null
  nullable    = true
}
