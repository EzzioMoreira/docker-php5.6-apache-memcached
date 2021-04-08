# Dockerfile php5.6 com modulos/extensões
## Reguisitos
- Docker
- Docker Compose

## Criando imagem
```
docker build -t nome/php.5.6:1.0
docker image ls
```
## Criando container
```
docker-compose up -d
docker-compose ps
```
## Acessando aplicação
- http://localhost/index.php

## Module instalados
* mysqli 
* mysql 
* pdo_mysql 
* bcmath pdo

## Modulos adicionais
* Memcached
* Mencache
* OpenSSL
* Imagick

## Volumes
* /var/www
* /var/log/apache2
* /etc/apache2

## Portas
* 80
* 443
