FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Asia/Shanghai \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y python2 python3 mono-devel wget unzip ca-certificates curl bash locales golang-go openjdk-17-jdk gcc g++ pypy3 php-cli nodejs npm ruby rustc && \
    locale-gen en_US.UTF-8 && \
    for security_file in /usr/lib/jvm/java-17-openjdk-*/conf/security/java.security; do \
        cp -L "$security_file" /tmp/java.security; \
        rm -f "$security_file"; \
        cp /tmp/java.security "$security_file"; \
    done && \
    rm -f /tmp/java.security && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /judge/test_case /judge/run /judge/spj /judge/log

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY *.jar /judge/server/app.jar

COPY run.sh /judge/server/run.sh

COPY check_nacos.sh /judge/server/check_nacos.sh

COPY testlib.h /usr/include/testlib.h

ADD Sandbox-amd64 /judge/server/Sandbox-amd64
ADD Sandbox-arm64 /judge/server/Sandbox-arm64
	
WORKDIR /judge/server

ENTRYPOINT ["bash", "./check_nacos.sh"]

EXPOSE 8088

EXPOSE 5050
