# Inspired by https://github.com/jprjr/docker-ubuntu-stack

FROM ubuntu:15.04
MAINTAINER Rahul Powar email: rahul@redsift.io version: 1.1.102

# Fix for stdin warnings as per https://github.com/mitchellh/vagrant/issues/1673#issuecomment-28287711
RUN sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# Set home
ENV HOME /root

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y rsyslog rsyslog-gnutls inotify-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy S6 across
COPY root /

ADD https://papertrailapp.com/tools/papertrail-bundle.pem /etc/papertrail-bundle.pem
RUN cd /etc/ && chmod 644 papertrail-bundle.pem && md5sum -c papertrail-bundle.pem.md5

# Define working directory.
WORKDIR /tmp

# Update .so cache
RUN ldconfig

# Generate the /etc/default/locale entries
# Disabled as Circleci prevents this working in LXC containers for now
# https://bugs.launchpad.net/ubuntu/+source/langpack-locales/+bug/931717
#
# RUN locale-gen en_GB.UTF-8 && update-locale LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8

# Prompt and shell settings
ENV TERM xterm-color

# RFC 5424 log levels http://en.wikipedia.org/wiki/Syslog#Severity_levels
# defaults to notice, overwrite with -e LOG_LEVEL=7
ENV LOG_LEVEL 5

# Change the onetime and fixup stage to terminate on error
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2

# S6 default entry point is the init added from the overlay
ENTRYPOINT [ "/init" ]