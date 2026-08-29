# CP04 - Containerização e Deploy na AWS

## Identificação

- **Aluno:** Guilherme Silva dos Santos
- **RM:** 551168
- **Turma:** 4ESPX
- **Disciplina:** Engenharia de Software
- **Data:** preencher

## 1. Objetivo

Este projeto demonstra a criação de um portal estático, sua containerização com Docker, a publicação da imagem no Docker Hub e a execução em uma instância Amazon EC2.

## 2. Portal personalizado

Descrever brevemente o conteúdo do portal e inserir o print da página.

**Evidência:** `01-site-local.png`

## 3. cgroups e namespaces

Namespaces isolam a visão que os processos possuem de recursos do sistema, como processos, rede, sistema de arquivos e usuários. cgroups medem e limitam o consumo de recursos, incluindo CPU, memória e operações de entrada e saída.

Em conjunto, esses mecanismos permitem que containers compartilhem o kernel do host mantendo isolamento e controle de recursos.

## 4. Construção da imagem Docker

Explicar o Dockerfile e inserir os prints do build e do container local.

**Evidências:** `02-docker-build.png` e `03-container-local.png`

## 5. Publicação no Docker Hub

Informar o endereço público da imagem e comprovar a existência da tag `cp04`.

**Evidências:** `04-docker-hub-publico.png` e `05-tag-cp04.png`

## 6. Infraestrutura AWS

Explicar a VPC, a sub-rede pública, o Internet Gateway, a tabela de rotas, o Security Group e a EC2.

**Evidências:** arquivos `06` a `12` da pasta `docs/evidencias`.

## 7. Aplicação em execução

Informar a URL pública da aplicação e inserir o print do navegador exibindo o portal carregado pela EC2.

**Evidência:** `13-site-ec2.png`

## 8. Conclusão

Resumir como a containerização tornou a implantação reproduzível e como a infraestrutura de rede permitiu o acesso público ao serviço.

## Links

- **GitHub:** preencher
- **Docker Hub:** preencher
- **URL temporária da EC2:** preencher
