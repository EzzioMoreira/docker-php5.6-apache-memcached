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

## Modulos adicionais
* Memcached
* Mencache

## Volumes
* /var/www
* /var/log/apache2

## Portas
* 80
* 443
