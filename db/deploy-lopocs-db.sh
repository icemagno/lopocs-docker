#! /bin/sh

#docker ps -a | awk '{ print $1,$2 }' | grep magnoabreu/lopocs-db:1.0 | awk '{print $1 }' | xargs -I {} docker rm -f {}
docker rmi magnoabreu/lopocs-db:1.0
docker build --tag=magnoabreu/lopocs-db:1.0 --rm=true .

docker run --name lopocs-db --hostname=lopocs-db \
-e POSTGRES_USER=postgres \
-e POSTGRES_PASS=admin \
-e POSTGRES_DBNAME=lopocs \
-e ALLOW_IP_RANGE='0.0.0.0/0' \
-e POSTGRES_MULTIPLE_EXTENSIONS=postgis,hstore,postgis_topology,postgis_sfcgal,pointcloud,pointcloud_postgis,morton \
-v /srv/lopocs-db/:/var/lib/postgresql/ \
-v /srv/lopocs-db-home/:/home/lopocs \
-v /etc/localtime:/etc/localtime:ro \
-d magnoabreu/lopocs-db:1.0


docker network connect sisgeodef lopocs-db
docker network connect apolo lopocs-db





