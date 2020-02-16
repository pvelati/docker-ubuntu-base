FROM ubuntu:xenial
LABEL maintainer="Paolo Velati"

# Set noninteractive only at build-time
ARG DEBIAN_FRONTEND=noninteractive

# Update sources and upgrade packages
RUN apt-get update \
    && apt-get -y upgrade 

# Install packages
RUN apt-get install -y --no-install-recommends \
       less nano vim-tiny zip unzip \
       sudo systemd curl systemd-sysv \
       build-essential wget libffi-dev libssl-dev \
       python3-pip python3-dev python3-setuptools python3-wheel

# Clean system
RUN rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/* /var/tmp/* \
    && apt-get clean \
    && apt-get -y autoremove

# Set default apps
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Prepare host for ansible 
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Make sure systemd doesn't start agettys on tty[1-6]
RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
