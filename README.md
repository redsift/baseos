# Docker container based on S6

| CI | Quay|
|----|-----|
|[![Circle CI](https://circleci.com/gh/Redsift/baseos.svg?style=svg)](https://circleci.com/gh/Redsift/baseos)|[![Docker Repository on Quay.io](https://quay.io/repository/redsift/baseos/status "Docker Repository on Quay.io")](https://quay.io/repository/redsift/baseos)|


Overlays [S6](https://github.com/just-containers/s6-overlay) into a new ubuntu and adds nanomsg.

## Running a shell

	$ docker run -ti --rm quay.io/redsift/baseos /bin/bash

## Init

Ensure your application `cont-init.d` files are numbered greater than 10 to ensure base scripts can run before you do. The 90 range is preferred e.g. `/etc/cont-init.d/90-confd-onetime`
	
## Logging

This container runs a rsyslogd much **against** the principles of a S6 container. This is a practical consideration given the requirements for our systems and the tooling.

### Remote

In addition to providing syslog like services, this container is built for shipping logs remotely. This is enabled by setting the environment variable TCP_SYSLOG to an appropriate `host:port` pair. [Papertrail](https://papertrailapp.com) over TCP with TLS is configured by default. Additional certificates would be required to enable others.

### Environment Variables

|Var|Description|Default|
|---|-----------|-------|
|`LOGGED_HOST`| Host shipped via syslog| `Container Id.Hostname`|
|`TCP_SYSLOG`|Destination for logs|None, logs go nowhere|

### Sending a Log

Normal syslog tools like `logger` will work.

	logger hello

You may also tag the message if you wish.

	logger -t iamspecial world

### Sending a Log from your App

Create a log script for S6 to redirect your output to and set it to `redirect-stdout` to forward logs. E.g. `/etc/services.d/confd/log/run`
	
	#!/usr/bin/execlineb -P

	redirect-stdout

`redirect-stdout` passes any parameters to [s6-log](http://skarnet.org/software/s6/s6-log.html) as Selection directives of the logging script.

Note, logs from conf-init.d scripts will not appear as rsyslogd is not running at this point.

#### Examples

Prepend a [TAI64N](http://skarnet.org/software/skalibs/libstddjb/tai.html) timestamp 

	redirect-stdout t
	
Prepend a [TAI64N](http://skarnet.org/software/skalibs/libstddjb/tai.html) timestamp and a [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601) timestamp.
	
	redirect-stdout t T
	
For all messages that contain ERROR send them prepending a TAI16N timestamp.
	
	redirect-stdout +ERROR t

You may manually invoke the pipe for testing purposes.

	echo "Testing" | redirect-stdout T

Note: This only captures STDOUT. If you have output going to STDERR that you want to capture, you need to redirect it in your service startup script. E.g. `/etc/services.d/confd/run`

	#!/usr/bin/execlineb -P
	
	fdmove -c 2 1
	...

or

	#!/bin/bash
	
	exec ... 2>&1


#### Waiting for /dev/log

For applications that expect /dev/log to be available at launch, it is best to wait until it has been created to mitigate any races.
	
	#!/usr/bin/execlineb -P
	
	foreground { waitfor-dev-log }
	...

#### Modifying configuration

If you need additional configuration, drop in your files e.g. add `/etc/rsyslog.d/49-udp.conf` to enable the standard UDP port though the standard `/dev/log` socket is a better choice.

	# UDP port

	$ModLoad imudp
	$UDPServerAddress 127.0.0.1
	$UDPServerRun 514
	
#### Log Frameworks

Some framework templates may produce a lot of redundancy with follow on logging services. Container, host and timestamps are generally already propagated.

