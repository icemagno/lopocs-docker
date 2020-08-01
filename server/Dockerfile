FROM becio/lopocs
MAINTAINER magno.mabreu@gmail.com

RUN mkdir /home/lopocs

COPY ./database.py /lopocs/lopocs/
COPY ./startup-server.sh /lopocs/

RUN cd /lopocs && pip3 install -e .

WORKDIR /lopocs

ENTRYPOINT ["/lopocs/startup-server.sh"]

CMD ["0.0.0.0"]
