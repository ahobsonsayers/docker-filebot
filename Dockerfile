# FileBot Dockerfile
# https://github.com/ahobsonsayers/docker-filebot

# Pull base image
FROM lsiobase/guacgui:latest

# Define filebot version
ARG FILEBOT_VERSION=4.7.9

LABEL build_version="FileBot Version: ${FILEBOT_VERSION}"
LABEL maintainer="Arran Hobson Sayers"
LABEL MAINTAINER="Arran Hobson Sayers"
ENV APPNAME="FileBot"

# Set Timezone
ARG TZ="Europe/London"
ENV TZ ${TZ}

# Define software download URLs.
ARG FILEBOT_URL=https://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VERSION}/FileBot_${FILEBOT_VERSION}-portable.tar.xz

# Define working directory.
WORKDIR /tmp

# Setup Environment
ENV DEBIAN_FRONTEND noninteractive

# Install FileBot.
RUN \
    apt-get update && \
    apt-get install -qy --no-install-recommends \
    curl xz-utils zip && \
    # Download sources.
    curl -# -L ${FILEBOT_URL} | tar xJ && \
    # Install.
    mkdir -p /opt/filebot/lib && \
    cp -v FileBot.jar /opt/filebot/ && \
    zip -d /opt/filebot/FileBot.jar com/sun/jna/* && \
    # Cleanup.
    rm -rf \
    /tmp/* \
    /tmp/.[!.]* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Install dependencies.
RUN \
    apt-get update && \
    apt-get install -qy --no-install-recommends \
    curl gtk+2.0 openjdk-8-jre libjna-java libmediainfo-dev \
    # OpenJFX8
    openjfx=8u161-b12-1ubuntu2 libopenjfx-java=8u161-b12-1ubuntu2 libopenjfx-jni=8u161-b12-1ubuntu2 \
    # AcousItD (fpcalc)
    libchromaprint-dev && \
    # Cleanup.
    rm -rf \
    /tmp/* \
    /tmp/.[!.]* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Add files.
COPY rootfs/ /

# Set startapp.sh to run with s6-overlay
RUN mkdir /etc/services.d/filebot && \
    ln /startapp.sh /etc/services.d/filebot/run

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]
