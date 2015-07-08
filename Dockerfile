# Inspired by https://github.com/jprjr/docker-ubuntu-stack

FROM ubuntu:15.04
MAINTAINER Rahul Powar email: rahul@redsift.io version: 1.1.101

# Fix for stdin warnings as per https://github.com/mitchellh/vagrant/issues/1673#issuecomment-28287711
RUN sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# Set home
ENV HOME /root

# Copy S6 across
COPY root /

# Define working directory.
WORKDIR /tmp

# Generate the /etc/default/locale entries
RUN locale-gen en_GB.UTF-8 && update-locale LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8

# Prompt and shell settings
ENV TERM xterm-color

# S6 default entry point, limit to 32 service directories and no scanning of new services
ENTRYPOINT ["/usr/bin/s6-svscan","-c","32","-t","0","/etc/s6"]
CMD []
