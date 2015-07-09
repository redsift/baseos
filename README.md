# Docker container based on S6

| CI | Quay|
|----|-----|
|[![Circle CI](https://circleci.com/gh/Redsift/baseos.svg?style=svg)](https://circleci.com/gh/Redsift/baseos)|[![Docker Repository on Quay.io](https://quay.io/repository/redsift/baseos/status "Docker Repository on Quay.io")](https://quay.io/repository/redsift/baseos)|


Overlays https://github.com/just-containers/s6-overlay into a new ubuntu and adds nanomsg.

## Running a shell


	$ docker run -ti --rm quay.io/redsift/baseos /bin/bash