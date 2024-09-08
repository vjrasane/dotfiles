FROM ubuntu:24.04

RUN apt update && apt install -y sudo wget
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
  apt install -y tzdata

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'ubuntu:ubuntu' | chpasswd

USER ubuntu
WORKDIR /home/ubuntu

