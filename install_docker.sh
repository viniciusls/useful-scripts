#!/bin/bash

echo "### Atualizando repositórios";
sudo apt update;

echo "### Instalando pacotes para permitir que o apt utilize pacotes via HTTPS e o curl";
sudo apt-get install -fy \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common;

echo "### Adicionando chave de assinatura do Docker";
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "### Adicionando repositório do Docker no apt";
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "### Atualizando repositórios";
sudo apt update;

echo "### Instalando Docker-CE";
sudo apt install -fy docker-ce;

echo "### Instalando Docker-compose (ATENÇÃO: funciona somente no Bash)";
sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose;

echo "### Atualizando permissões do docker-compose";
sudo chmod +x /usr/local/bin/docker-compose;

echo "### Concluído!"
