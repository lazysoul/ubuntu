FROM ubuntu:20.04

MAINTAINER Lyan Nam <i@lazysoul.com>

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get clean && apt-get update && apt-get install -y locales

# Set locales
RUN locale-gen en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Set Timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set Korea source.list
RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
RUN sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && apt-get install dialog apt-utils -y --no-install-recommends \
                curl \
                wget \
                vim \
                net-tools \
                sudo \
                sysstat \
                iputils-ping \
                systemd \
                git \
                openssh-client \
                gnupg2 \
                ca-certificates \
                build-essential \
                zsh \
                fonts-powerline \
                && rm -rf /var/lib/apt/lists/*
                
RUN wget -c https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local                               
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc
RUN mkdir -p /work/go
RUN echo "export GOPATH=/work/go" >> /root/.bashrc
# terminal colors with xterm
ENV TERM xterm
# set the zsh theme
ENV ZSH_THEME agnoster
# run the installation script  
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
# start zsh
CMD [ "zsh" ]
