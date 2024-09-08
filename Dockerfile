FROM ubuntu:24.04

RUN apt update && apt install -y sudo wget
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
  apt install -y tzdata
RUN apt update && apt install -y software-properties-common
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt update && apt install -y ansible
RUN apt update && apt install -y curl

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'ubuntu:ubuntu' | chpasswd

USER ubuntu
WORKDIR /home/ubuntu

