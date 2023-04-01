FROM ubuntu:latest
LABEL maintaner="Robert Nowotniak <rnowotniak@metasolid.tech>"

ARG ARCH=x86_64
ENV ARCH=x86_64
ARG DROPBOXBIN_URL=https://www.dropbox.com/download?plat=lnx.$ARCH
ARG DROPBOXPY_URL=https://www.dropbox.com/download?dl=packages/dropbox.py

WORKDIR /root

RUN apt-get update && apt-get upgrade
RUN apt-get install -y python3 wget
RUN wget --no-verbose -O /var/tmp/dropbox.$ARCH.tgz "$DROPBOXBIN_URL"
RUN wget -O /var/tmp/dropbox.py "$DROPBOXPY_URL" && chmod 700 /var/tmp/dropbox.py

ENV PATH="$PATH:/root/bin"

CMD mkdir -p ~/bin; mv /var/tmp/dropbox.py ~/bin/ ; cd && tar xzvf /var/tmp/dropbox.$ARCH.tgz && ~/.dropbox-dist/dropboxd

