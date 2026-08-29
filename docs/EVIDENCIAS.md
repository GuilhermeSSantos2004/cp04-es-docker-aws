# Roteiro de evidências da CP04

Este documento lista os prints necessários para montar o PDF final. Não utilize imagens simuladas: todas as evidências devem vir da execução real.

## Organização atual

As capturas disponíveis já estão nesta pasta com nomes descritivos:

```text
docs/evidencias/
├── 01-site-namespaces-cgroups.png
├── 02-site-portal-ec2.png
├── 03-cloudshell-vpc-subnet-igw.png
├── 04-cloudshell-rotas-associacao.png
├── 05-cloudshell-security-group-ec2.png
├── 06-ec2-detalhes-rede.png
├── 07-cloudshell-ec2-running.png
├── 08-cloudshell-terraform-output.png
└── 09-cloudshell-igw-rotas.png
```

O pacote ainda precisa das capturas do topo do portal com nome/RM/turma, do build e container Docker e do Docker Hub público com a tag `cp04` para atender todos os itens do checklist visual.

## Checklist por critério

### 1. Site personalizado - 1,5 ponto

- [ ] Página completa aberta no navegador.
- [ ] Nome `Guilherme Silva dos Santos` visível.
- [ ] RM `551168` visível.
- [ ] Turma `4ESPX` visível.
- [ ] Seções sobre cgroups e namespaces legíveis.

### 2. Dockerfile e imagem - 2,5 pontos

- [ ] Terminal mostrando `docker build` concluído sem erro.
- [ ] `docker image ls` mostrando a imagem.
- [ ] Container local em execução com `docker ps`.
- [ ] Portal local aberto em `http://localhost:8080`.

### 3. Docker Hub - 2,0 pontos

- [ ] Página do repositório Docker Hub com visibilidade pública.
- [ ] Tag `cp04` claramente visível.
- [ ] Nome completo da imagem legível.

### 4. EC2 na nuvem - 3,0 pontos

- [ ] VPC `10.0.0.0/24`.
- [ ] Sub-rede com atribuição de IPv4 público.
- [ ] Internet Gateway conectado.
- [ ] Rota `0.0.0.0/0` para o gateway.
- [ ] Associação entre tabela de rotas e sub-rede.
- [ ] Security Group com porta 80 liberada.
- [ ] EC2 no estado `Running`.
- [ ] IP público da instância.
- [ ] Saída do `terraform apply` ou etapas equivalentes no Console.
- [ ] Portal aberto por `http://IP_PUBLICO`.

### 5. Documento final - 1,0 ponto

- [ ] Capa com nome, RM, turma e título.
- [ ] Sumário curto.
- [ ] Prints na ordem do processo.
- [ ] Legendas explicando cada evidência.
- [ ] Texto e terminais legíveis.
- [ ] URL do GitHub e do Docker Hub.
- [ ] Conclusão.
- [ ] PDF aberto e revisado antes do envio.

## Cuidados antes do print

- Nunca mostre access keys, session tokens, senhas ou tokens.
- Mascare IDs sensíveis se o professor não precisar deles.
- Não corte a informação principal da tela.
- Use zoom que mantenha o texto legível.
- Registre a URL pública funcionando antes de destruir a infraestrutura.
