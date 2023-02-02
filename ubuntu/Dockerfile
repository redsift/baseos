# Inspired by https://github.com/jprjr/docker-ubuntu-stack

FROM ubuntu:18.04

# Fix for stdin warnings as per https://github.com/mitchellh/vagrant/issues/1673#issuecomment-28287711
RUN sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# Set home
ENV HOME /root

# Install rsyslog (for remote syslog), inotify (for FS changes), lsb-release (for scripts)
# iproute (for basic ip checks) and e3 (for tiny editing)
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y locales lsb-release iproute2 e3 ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Cleanup default cron tasks
RUN rm -f /etc/cron.hourly/* /etc/cron.daily/* /etc/cron.weekly/*  /etc/cron.monthly/*

# Copy S6 across
COPY root /

# Define working directory.
WORKDIR /tmp

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
	apt-get install -y \
  curl autoconf libtool make cmake pkg-config && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install nanomsg
# Due to 0.9 rename to nanomsg, some older bindings break so alias nanomsg.pc to libnanomsg.pc - should be removed later
ENV NANO_MSG=1.1.2
RUN cd /tmp && curl -L https://github.com/nanomsg/nanomsg/archive/$NANO_MSG.tar.gz | tar xz && \
  cd /tmp/nanomsg-$NANO_MSG && mkdir build && cd build && cmake .. && cmake --build . && cmake --build . --target install && \
  ln -s /usr/local/lib/pkgconfig/nanomsg.pc /usr/local/lib/pkgconfig/libnanomsg.pc && \
  rm -rf /tmp/nanomsg-$NANO_MSG

# pkg-config is needed for nanomsg
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# Update .so cache
RUN ldconfig

# Generate the /etc/default/locale entries
# Disabled as Circleci prevents this working in LXC containers for now
# https://bugs.launchpad.net/ubuntu/+source/langpack-locales/+bug/931717
#
# RUN locale-gen en_GB.UTF-8 && update-locale LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8

# Fix for ubuntu to ensure /etc/default/locale is present
RUN update-locale

# Prompt and shell settings
ENV TERM xterm-color

# RFC 5424 log levels http://en.wikipedia.org/wiki/Syslog#Severity_levels
# defaults to notice, overwrite with -e LOG_LEVEL=7
ENV LOG_LEVEL 5

# Change the onetime and fixup stage to terminate on error
# Keep container environment variables
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 S6_KEEP_ENV=1

# S6 default entry point is the init added from the overlay
ENTRYPOINT [ "/custom-init" ]
