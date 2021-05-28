FROM ubuntu:18.04
LABEL maintainer="shockwavenn@gmail.com"

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY . /root
EXPOSE 80
