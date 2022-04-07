FROM python:alpine3.15
MAINTAINER Sea <lshan523@163.com>
VOLUME /tmp
RUN pip3 install --default-timeout=1000 --no-cache-dir --upgrade pip pyftpdlib
RUN  mkdir -p /opt/ftp/anonymous
RUN  mkdir -p /opt/ftp/user
RUN  chmod -R  777  /opt/ftp/user
RUN  chmod -R  777  /opt/ftp/anonymous
## install GBK
#COPY locale.md 　/locale.md
##******************使用国内的镜像Alpine安装 Glibc https://github.com/sgerrand/alpine-pkg-glibc ****
#RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.9/main/" > /etc/apk/repositories && \
#apk --no-cache add ca-certificates wget && \
#wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
#wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
#wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk && \
#wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-i18n-2.30-r0.apk && \
#apk add glibc-bin-2.30-r0.apk glibc-i18n-2.30-r0.apk glibc-2.30-r0.apk && \
#cat locale.md | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8 && \
#rm -rf *.apk && \
#rm -rf /var/cache/apk/* && \
#rm -rf locale.md


# Install language pack
RUN apk --no-cache add ca-certificates wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk && \
    apk add glibc-bin-2.25-r0.apk glibc-i18n-2.25-r0.apk glibc-2.25-r0.apk

# Iterate through all locale and install it
# Note that locale -a is not available in alpine linux, use `/usr/glibc-compat/bin/locale -a` instead
COPY ./locale.md /locale.md
RUN cat locale.md | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8

COPY docker-entrypoint.sh /opt/
#add python code
COPY  MyFtpServer.py   /opt/

# Set the lang, you can also specify  it as as environment variable through docker-compose.yml
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
WORKDIR /opt/
ENTRYPOINT ["sh","/opt/docker-entrypoint.sh"]
EXPOSE 30000-30010
