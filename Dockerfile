FROM python:alpine3.15
MAINTAINER Sea <lshan523@163.com>
VOLUME /tmp
RUN pip3 install --default-timeout=1000 --no-cache-dir --upgrade pip pyftpdlib
RUN  mkdir -p /opt/ftp/anonymous
RUN  mkdir -p /opt/ftp/user
RUN  chmod -R  777  /opt/ftp/user
RUN  chmod -R  777  /opt/ftp/anonymous
COPY docker-entrypoint.sh /opt/
#add python code
COPY  MyFtpServer.py   /opt/
WORKDIR /opt/
ENTRYPOINT ["sh","/opt/docker-entrypoint.sh"]
EXPOSE 30000-30010
