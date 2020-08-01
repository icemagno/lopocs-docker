docker run --name lopocs-orig --hostname lopocs-orig -ti -p 5000:5000 -e "PG_HOST=lopocs-db" -e "PG_NAME=lopocs" -e "PG_PORT=5432" -e "PG_USER=postgres" -e "PG_PASSWORD=admin" becio/lopocs


docker run --name lopocs-orig --hostname lopocs-orig -it -p 5000:5000 -v /home/magno/lopocs-db/server/:/lopocs/conf becio/lopocs 


docker run --name lopocs-orig --hostname lopocs-orig -d -p 5000:5000 -v /home/magno/lopocs-db/server/:/lopocs/conf becio/lopocs lopocs serve --host 0.0.0.0


docker network connect sisgeodef lopocs-orig
docker network connect apolo lopocs-orig