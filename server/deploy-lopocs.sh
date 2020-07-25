#! /bin/sh

docker ps -a | awk '{ print $1,$2 }' | grep magnoabreu/lopocs:1.0 | awk '{print $1 }' | xargs -I {} docker rm -f {}
docker rmi magnoabreu/lopocs:1.0
docker build --tag=magnoabreu/lopocs:1.0 --rm=true .

docker run --name lopocs --hostname=lopocs \
-v /srv/lopocs-home/:/home/lopocs \
-v /etc/localtime:/etc/localtime:ro \
-p 36500:5000 \
-it magnoabreu/lopocs:1.0 /bin/bash



