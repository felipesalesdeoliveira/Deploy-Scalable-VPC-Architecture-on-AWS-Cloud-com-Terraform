# 🌐 Deploy de Arquitetura VPC Escalável na AWS

![AWS-Cloud](https://imgur.com/AXD50yl.png)

## 📌 Sobre o Projeto

Este projeto demonstra a implementação de uma arquitetura de rede modular, escalável e altamente disponível utilizando Amazon VPC.

A solução foi projetada para simular um ambiente corporativo real, com separação entre camadas administrativas e aplicação, conectividade privada entre VPCs, controle de tráfego e observabilidade completa via Flow Logs.

O objetivo principal é construir uma base de infraestrutura preparada para workloads escaláveis e ambientes seguros em produção.

---

# 🏗️ Arquitetura da Solução

A arquitetura é composta por duas VPCs separadas:

## 🔹 VPC 1 – Camada Administrativa (Bastion)
- CIDR: `192.168.0.0/16`
- Subnet Pública
- Bastion Host com Elastic IP
- Internet Gateway
- Security Group restritivo (porta 22)

## 🔹 VPC 2 – Camada de Aplicação
- CIDR: `172.32.0.0/16`
- Subnets Públicas e Privadas distribuídas em múltiplas AZs
- Auto Scaling Group
- Network Load Balancer
- NAT Gateway para tráfego de saída
- Instâncias privadas altamente disponíveis

## 🔹 Conectividade entre VPCs
- AWS Transit Gateway
- Comunicação privada segura entre ambientes

---

# 🧠 Decisões Arquiteturais

- Separação de VPCs para isolamento administrativo
- Uso de subnets privadas para servidores de aplicação
- NAT Gateway para permitir saída à internet sem expor instâncias
- Bastion Host para acesso SSH controlado
- Uso de Session Manager para reduzir dependência de SSH público
- VPC Flow Logs para auditoria e rastreamento de tráfego
- Auto Scaling para garantir resiliência e elasticidade

---

# ⚙️ Stack Tecnológica

- AWS VPC
- EC2
- Auto Scaling Group
- Network Load Balancer
- Transit Gateway
- NAT Gateway
- CloudWatch
- VPC Flow Logs
- IAM
- Route 53
- S3
- Apache Web Server
- AWS CLI
- AWS Systems Manager (SSM)

---

# 🔄 Pré-Deploy (Golden AMI)

Foi criada uma Golden AMI contendo:

- AWS CLI configurado
- Apache Web Server instalado
- Git
- CloudWatch Agent
- Script para envio de métricas customizadas de memória
- AWS SSM Agent

Essa abordagem reduz tempo de provisionamento e garante padronização das instâncias.

---

# 🚀 Provisionamento da Infraestrutura

## 1️⃣ Construção das VPCs

- VPC 1: `192.168.0.0/16`
- VPC 2: `172.32.0.0/16`

## 2️⃣ Gateways

- Internet Gateway para ambas as VPCs
- NAT Gateway na subnet pública
- Atualização das Route Tables para roteamento adequado

## 3️⃣ Transit Gateway

- Associação das duas VPCs
- Comunicação privada entre camadas

## 4️⃣ Observabilidade

- Criação de CloudWatch Log Groups
- Dois Log Streams dedicados
- Ativação de VPC Flow Logs para ambas as VPCs

---

# 📦 Camada de Aplicação

## Launch Configuration

- Golden AMI
- Instance Type: `t2.micro`
- UserData:
  - Pull do código do repositório
  - Deploy no DocumentRoot
  - Start do serviço httpd
- IAM Role com:
  - Acesso ao SSM
  - Permissão restrita ao bucket S3 de configuração
- Security Group:
  - Porta 22 apenas do Bastion
  - Porta 80 pública
- Key Pair

## Auto Scaling Group

- Min: 2
- Max: 4
- Subnets privadas distribuídas em AZ 1a e 1b

## Load Balancer

- Network Load Balancer público
- Target Group associado ao ASG

## DNS

- Registro CNAME configurado no Route 53
- Domínio apontando para o NLB

---

# 🔐 Segurança Implementada

## Rede
- Princípio de menor privilégio
- Instâncias privadas não expostas à internet
- Bastion como ponto único de entrada SSH
- Session Manager para acesso seguro via console

## Monitoramento
- VPC Flow Logs habilitados
- Logs centralizados no CloudWatch
- Métricas customizadas de memória

## IAM
- Permissões mínimas necessárias
- Evitado uso de políticas amplas como S3 Full Access

---

# 📊 Validação

- Acesso às instâncias privadas via Bastion Host
- Acesso via AWS Session Manager
- Teste da aplicação via navegador público utilizando domínio configurado
- Verificação de escalabilidade automática ao gerar carga

---

# 📈 Resultados Técnicos

✔ Arquitetura modular e isolada  
✔ Comunicação privada entre VPCs  
✔ Alta disponibilidade com Auto Scaling  
✔ Controle de acesso seguro  
✔ Observabilidade implementada  
✔ Ambiente pronto para produção  

---

# 📚 Aprendizados Aplicados

- Design de redes complexas na AWS
- Estratégias de isolamento entre ambientes
- Implementação de alta disponibilidade
- Observabilidade de tráfego em nível de VPC
- Boas práticas de segurança e IAM
- Integração de DNS com Load Balancer

---

# 🤝 Contribuição

1. Fork do repositório  
2. Criar branch  
3. Commit  
4. Push  
5. Pull Request  

---

# ⭐ Se este projeto foi útil

Considere:

- Dar uma estrela ⭐
- Compartilhar com sua rede
- Contribuir com melhorias

---

> Este projeto simula uma arquitetura corporativa real focada em escalabilidade, segurança e alta disponibilidade na AWS.
