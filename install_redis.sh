#!/bin/sh

echo "### Atualizando repositórios"
sudo apt update

echo "### Alterando diretório atual para /tmp"
cd /tmp

echo "### Baixando pacote redis-stable"
wget http://download.redis.io/redis-stable.tar.gz

echo "### Extraindo pacote redis-stable"
tar vzxf redis-stable.tar.gz

echo "### Alterando diretório atual para ./redis-stable"
cd redis-stable

echo "### Compilando binários"
sudo make

echo "### Testando binários compilados"
sudo make test

echo "### Instalando binários no sistema"
sudo make install

echo "### Criando diretório de configuração do Redis em /etc/redis"
sudo mkdir /etc/redis

echo "### Copiando configuração padrão para o diretório de configuração criado"
sudo cp /tmp/redis-stable/redis.conf /etc/redis

echo "### Adicionado configurações adicionais"
sudo sed -i 's/supervised no/supervised systemd/g'
#sudo sed -i 's_dir_dir /var/lib/redis_g' (additional tests required)

echo "### Criando systemd unit file para que o sistema de inicialização possa gerenciar o processo do Redis"
sudo echo "[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/redis.service

echo "### Criando usuário e grupo 'redis'"
sudo adduser --system --group --no-create-home redis

echo "### Criando diretório /var/lib/redis"
sudo mkdir /var/lib/redis

echo "### Alterando proprietário e permissões para o diretório /var/lib/redis ao usuário/grupo 'redis'"
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis

echo "### Habilitando inicialização automática do Redis Server no boot"
sudo systemctl enable redis

echo "### Iniciando o Redis Server"
sudo systemctl start redis

echo "### Obtendo status de inicialização do serviço Redis Server"
sudo systemctl status redis

echo "### Concluído!"
