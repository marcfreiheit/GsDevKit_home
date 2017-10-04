# Version of stone 
ARG GEMSTONEVERSION=3.3.0

# Known to have best compatibility
FROM ubuntu:14.04

ENV GS_HOME=/home/gs/GsDevKit_home
ENV PATH="${GS_HOME}/bin:${PATH}"
ENV DEBIAN_FRONTEND noninteractive

# Check out this installation guide
LABEL docs.installation="https://github.com/GsDevKit/GsDevKit_home/blob/master/docs/installation/installDevKitServer.md"

# set password for root
RUN echo "root:Docker!" | chpasswd

# create user to execute installation comamnds
RUN adduser gs

# update and install git to clone server app
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get autoremove && \
    apt-get install -y git

# Most commands shouldn't be executed as root
USER gs

WORKDIR /home/gs

RUN git clone https://github.com/GsDevKit/GsDevKit_home.git

COPY . .

USER root
RUN chmod +x ./install.sh

USER gs
RUN ./install.sh

RUN createStone devKit_33 $GEMSTONEVERSION |& tee -a $GS_HOME/install.log
