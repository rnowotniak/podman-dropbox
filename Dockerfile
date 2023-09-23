FROM ubuntu:latest
LABEL maintaner="Robert Nowotniak <rnowotniak@metasolid.tech>"

ARG ARCH=x86_64
ENV ARCH=x86_64
ARG DROPBOXBIN_URL=https://www.dropbox.com/download?plat=lnx.$ARCH
ARG DROPBOXPY_URL=https://www.dropbox.com/download?dl=packages/dropbox.py

# root in the container will be the same UID as your (non-root) user outside.
# Otherwise (non-root in container) there would be permission issues with your Dropbox files (different ownership inside and outside the container)
USER root
WORKDIR /root

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y python3 wget
RUN wget --no-verbose -O /var/tmp/dropbox.$ARCH.tgz "$DROPBOXBIN_URL"
RUN wget -O /var/tmp/dropbox.py "$DROPBOXPY_URL" && chmod 700 /var/tmp/dropbox.py

ENV PATH="$PATH:/root/bin"

COPY --chmod=0700 run.sh /var/tmp/
CMD exec /var/tmp/run.sh

