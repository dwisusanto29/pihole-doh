FROM pihole/pihole

MAINTAINER Dwi Susanto <su@santo.my.id>

EXPOSE 53:53/tcp 53:53/udp 67:67/udp 80:80/tcp

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y autoremove --purge \
    && apt-get -y install wget

RUN wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-arm.tgz$
    && tar -xvzf cloudflared-stable-linux-arm.tgz \
    && sudo cp ./cloudflared /usr/local/bin \
    && sudo chmod +x /usr/local/bin/cloudflared \
    && cloudflared -v

#RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/$
#    && apt-get install ./cloudflared-linux-arm64.deb \
#    && mkdir -p /etc/cloudflared/ 

COPY ./config.yml /etc/cloudflared/config.yml

RUN cloudflared service install --legacy

COPY ./startup /etc/startup

RUN mkdir -p /etc/pihole-doh/logs/pihole \
    && chmod +x /etc/startup

ENTRYPOINT ["/etc/startup"]
