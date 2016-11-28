#!/bin/sh
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv \
               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get install -y docker-engine
sudo service docker start
# run guacd
sudo docker run --name some-guacd -d glyptodon/guacd
sudo docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=PassW0rd! -d mysql:latest
sudo docker run --rm glyptodon/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
# create database
curl --url https://raw.githubusercontent.com/kreuzhofer/guacamole-azure/master/scripts/create-db.sql > create-db.sql
sudo docker cp ./create-db.sql some-mysql:/
sudo docker cp ./initdb.sql some-mysql:/
sudo docker exec some-mysql sh -c 'exec mysql -u root -pPassW0rd! < /create-db.sql'
sudo docker exec some-mysql sh -c 'exec mysql -u root -pPassW0rd! < /initdb.sql'
