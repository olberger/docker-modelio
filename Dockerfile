# modelio-5.1.0 on Debian-based image
#
# WARNING : PLEASE READ README.md
#
# References:
#   https://github.com/pascalpoizat/docker-modelio
#   https://github.com/mdouchement/docker-zoom-us
#   https://github.com/sameersbn/docker-skype

FROM debian:bullseye-slim

# Based on that initial version, and Pascal Poizat's
#LABEL maintainer="gerald.hameau@gmail.com"
LABEL maintainer="olivier.berger@telecom-sudparis.eu"

ENV DEBIAN_FRONTEND=noninteractive

ARG USER_ID=1000
ARG GROUP_ID=1000

# System
RUN apt-get update
RUN apt-get -qy dist-upgrade

RUN apt-get install -qy --no-install-recommends \
    wget sudo \
    libgtk-3-0 libwebkit2gtk-4.0-37

RUN apt install -qy ca-certificates

# We don't need to install from sources, since the project distributes a Debian package (which includes the JRE)
# RUN mkdir /modelio && \
#     cd /modelio && \
#     wget -nv --show-progress --progress=bar:force:noscroll -O modelio.tar.gz https://github.com/ModelioOpenSource/Modelio/releases/download/v4.1.0/Modelio.4.1.0.-.Linux.tar.gz && \
#     tar xfz modelio.tar.gz && \
#     rm -rf modelio.tar.gz
RUN wget -nv --show-progress --progress=bar:force:noscroll -O Debian.modelio-open-source5.1_5.1.0_amd64.deb https://github.com/ModelioOpenSource/Modelio/releases/download/v5.1.0/Debian.modelio-open-source5.1_5.1.0_amd64.deb && \
    dpkg -i Debian.modelio-open-source5.1_5.1.0_amd64.deb
#    || \
#    apt-get --fix-broken install -qy


# RUN mkdir -p /etc/modelio-open-source4.1
# COPY modelio.config /etc/modelio-open-source4.1

COPY scripts/ /var/cache/modelio/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
