FROM becio/lopocs
MAINTAINER magno.mabreu@gmail.com

COPY ./database.py /lopocs/popocs/
COPY ./startup-server.sh /lopocs/

WORKDIR /lopocs

ENTRYPOINT["/lopocs/startup-server.sh"]

CMD["0.0.0.0"]
