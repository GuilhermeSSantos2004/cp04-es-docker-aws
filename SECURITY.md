# Segurança e credenciais

## Nunca publique

- `aws_access_key_id`;
- `aws_secret_access_key`;
- `aws_session_token`;
- senha ou token do Docker Hub;
- token pessoal do GitHub;
- chave privada `.pem`;
- arquivos `terraform.tfstate` e `terraform.tfvars` reais.

O `.gitignore` já bloqueia os arquivos locais mais comuns, mas revise sempre o conteúdo antes de cada commit.

## AWS Academy

Use credenciais temporárias em um perfil local chamado `academy`. Quando expirarem, substitua os três valores no arquivo de credenciais do seu usuário. Não copie o bloco para issues, commits, prints ou mensagens.

## Docker Hub e GitHub Actions

Use um access token exclusivo do Docker Hub e armazene-o como secret `DOCKERHUB_TOKEN`. O secret `DOCKERHUB_USERNAME` contém apenas o nome do usuário.

## Acesso SSH

A porta 22 fica fechada por padrão. Se for necessário habilitá-la, use apenas o seu endereço IPv4 com máscara `/32` e um key pair já existente. Nunca libere SSH para `0.0.0.0/0`.

## Terraform state

O estado do Terraform pode conter detalhes da infraestrutura. Neste trabalho ele permanece local e não deve ser enviado ao GitHub.
