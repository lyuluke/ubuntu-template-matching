FROM ubuntu:18.04
LABEL  maintainer="LK"
ENV DEBIAN_FRONTEND noninteractive
COPY entry_point.sh /opt/bin/entry_point.sh
RUN \
#==================================================
# Ubuntu chinese source
#==================================================
  #sed -i "s@http://.*archive.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list && \
  #sed -i "s@http://.*security.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list && \
#==================================================
# sudo
#==================================================
  apt-get update &&\
  apt-get -y install sudo &&\
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
#==================================================
# sudo passwd
#==================================================
  sudo useradd seluser --shell /bin/bash --create-home &&\
  sudo usermod -a -G sudo seluser &&\
  echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers &&\
  echo 'seluser:a123456789' | chpasswd &&\
  
#==================================================
# xvfb X11VNC
#==================================================
  apt-get update &&\
  apt-get -qqy install \
    xvfb &&\
  apt-get -qqy install x11vnc &&\
  rm -rf /var/lib/apt/lists/* &&\
  mkdir -p ~/.vnc &&\
  x11vnc -storepasswd a123456789 ~/.vnc/passwd &&\
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  apt-get update && apt-get -qqy install \
     x.org \
     fluxbox &&\
  apt-get clean && rm -rf /var/lib/apt/lists/* && \

#==================================================
# supervisor
#==================================================
  apt-get update && sudo apt-get install -y supervisor &&\
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  
#==================================================
# Python3.6
#==================================================
  apt-get update &&\
  apt-get -qqy --no-install-recommends install \
    python3.6 \
    python-dev \
    python3-dev \
    python3-pip \
    python3-setuptools \
    build-essential \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    python-pip \
    curl \
    git \
    supervisor \
    libltdl-dev &&\

#==================================================
# Flask
#==================================================
  pip3 install wheel &&\
  pip3 install flask_restplus &&\
  pip3 install requests &&\
  pip3 install opencv-python &&\
  pip3 install vncdotool &&\
  pip3 install paramiko &&\

#==================================================
# apt clean
#==================================================
  apt-get clean && rm -rf /var/lib/apt/lists/* &&\

#==================================================
# entry_point.sh
#==================================================
  chmod +x /opt/bin/entry_point.sh
  
#==================================================
# Env
#==================================================  
#ENV SCREEN_WIDTH 1920
#ENV SCREEN_HEIGHT 1200
#ENV SCREEN_DEPTH 24
#ENV DISPLAY :0	
#EXPOSE 5900
