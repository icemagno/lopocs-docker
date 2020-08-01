#!/bin/bash

docker ps -a | awk '{ print $1,$2 }' | grep magnoabreu/lopocs:1.0 | awk '{print $1 }' | xargs -I {} docker rm -f {}
docker rmi magnoabreu/lopocs:1.0
docker build --tag=magnoabreu/lopocs:1.0 --rm=true .

mkdir /srv/lopocs-conf/
cp ./lopocs.yml /srv/lopocs-conf/

docker run --name lopocs --hostname=lopocs \
-v /srv/lopocs-home/:/home/lopocs \
-v /etc/localtime:/etc/localtime:ro \
-v /srv/lopocs-conf/:/lopocs/conf \
-p 36500:5000 \
-d magnoabreu/lopocs:1.0

docker network connect sisgeodef lopocs
docker network connect apolo lopocs

cp ./congonhas.las /srv/lopocs-home/

