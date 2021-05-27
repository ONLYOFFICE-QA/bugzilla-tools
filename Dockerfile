FROM ubuntu:18.04
LABEL maintainer="shockwavenn@gmail.com"

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY . /root
EXPOSE 80
CMD ["bash", "/root/entrypoint.sh"]
