# Version of stone 
ARG GEMSTONEVERSION=3.4.0

# Known to have best compatibility
FROM ubuntu:14.04

ENV GS_SERVER_SETUP_HOME=/home/gs/GsDevKit_home/docker/ubuntu/14.04
ENV GS_HOME=/home/gs/GsDevKit_home
ENV PATH="${GS_HOME}/bin:${PATH}"
ENV DEBIAN_FRONTEND noninteractive

# Check out this installation guide
LABEL docs.installation="https://github.com/HPI-SWA-Lab/BP2017RH1/wiki/Installation-Guide"

# create user to execute installation comamnds
RUN adduser gs
WORKDIR /home/gs

# update and install git to clone server app
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get autoremove && \
    apt-get install -y git curl zip unzip libpam0g:i386 libssl1.0.0:i386 gcc-multilib libstdc++6:i386 gdb libfreetype6:i386 pstack libgl1-mesa-glx:i386 libxcb-dri2-0:i386

# Copy scripts to install server
RUN mkdir GsDevKit_home
COPY ../../../../ ./GsDevKit_home

# Setting up shared memory
RUN chmod +x ./install.sh && \
    ./docker/ubuntu/14.04/installServer.sh

# Most commands shouldn't be executed as root
USER gs
RUN ./install.sh

RUN createStone devKit_33 $GEMSTONEVERSION |& tee -a $GS_HOME/install.log