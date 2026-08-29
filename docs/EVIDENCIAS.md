# Roteiro de evidências da CP04

Este documento lista os prints necessários para montar o PDF final. Não utilize imagens simuladas: todas as evidências devem vir da execução real.

## Organização sugerida

Salve os arquivos nesta pasta com nomes numerados:

```text
docs/evidencias/
├── 01-site-local.png
├── 02-docker-build.png
├── 03-container-local.png
├── 04-docker-hub-publico.png
├── 05-tag-cp04.png
├── 06-vpc.png
├── 07-subnet-publica.png
├── 08-internet-gateway.png
├── 09-tabela-de-rotas.png
├── 10-security-group.png
├── 11-ec2-running.png
├── 12-terraform-apply.png
└── 13-site-ec2.png
```

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
