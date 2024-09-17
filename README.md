# olberger/docker-modelio

# Introduction

[Modelio](https://www.modelio.org) 5.4.1 in a docker container (for Linux, and maybe for macOS too)

The image uses [X11](http://www.x.org) unix domain socket on the host to enable display of the Modelio desktop app. These components are available out of the box on pretty much any modern linux distribution.

OpenJDK 11 is installed, inside the container in `/usr/local/openjdk-11` (for use in Java Designer module's parameters).


# WARNINGS

* Once Launched :
    * The host shares X11 socket and IPC with the container
    => This breaks container isolation, and the contained app can listen to all X11 events !
    * **The host shares your ~/.modelio/ and ~/Documents/ModelioWorkspace/ folders (by default) with the container.**
* Use it at your own risk !

# Getting started

## Requirements

* Docker (https://www.docker.com) running
* X11 (tested with https://www.xquartz.org on macOS Catalina 10.15.7) running

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/olberger/docker-modelio) and is the recommended method of installation.

```bash
docker pull olberger/docker-modelio:5.4.1
```

Alternatively you can build the image yourself, from the contents of
the Github repo.

<!-- docker build --pull -t olberger/docker-modelio . -->

```bash
docker rmi olberger/docker-modelio:5.4.1
docker build -t olberger/docker-modelio:5.4.1 github.com/olberger/docker-modelio#5.4.1
```

With the image locally available, install the wrapper script by running the following as root:

```bash
docker run -it --rm \
  --volume /usr/local/bin:/target \
  olberger/docker-modelio:5.4.1 install
```

This will install a wrapper script named  `modelio-wrapper-5.4.1` to
launch Modelio inside a container (details and options below).

## Setup on Mac (perform once)

THIS SECTION WASN'T TESTED AND SHOULD BE CHECKED. PULL REQUESTS WELCOME

1. launch XQuartz
2. in Preferences -> Security check "Authenticate connections" and "Allow connections from network clients"
3. exit and re-launch XQuartz
4. clone this repository (NOT YET UPDATED SINCE I HAVE NO MAC TO TEST
    MY REPO'S)
    ```sh
    git clone https://github.com/olberger/docker-modelio
    ```
5. enter the repository
    ```sh
    cd docker-modelio
    ```
6. build (optional, to specify architecture for M1 (apple silicon) macOS.)
    ```sh
    docker build --platform linux/amd64 --tag olberger/docker-modelio:5.4.1 .
    ```
7. enable the `run.sh` script to be run
    ```sh
    chmod +x run.sh
    ```

## Starting Modelio

### On Linux

Launch the `modelio-wrapper-5.4.1` script to enter a shell inside the
Docker container (or directly `modelio` if you don't have multiple
versions installed):

```bash
modelio-wrapper-5.4.1 bash
```

Then the prompt should be displayed like:
```
Cleaning up stopped instances of the modelio container...
Using MODELIO_HOME: /home/olivier
Mounting '/home/olivier/Documents/ModelioWorkspace' on the host into '/home/modelio/modelio/workspace' on the guest
Limiting to 2.0 cpus for the container
Starting bash inside the container...
Inside the running container...
You can now launch Modelio 5.4.1 by invoking '/usr/bin/modelio-open-source5.4.1' at the bash prompt, and quit with 'exit' at the end.
modelio@9749358c4a9d:~$ 
```

then type `/usr/bin/modelio-open-source5.4.1` at the prompt inside the
container, as instructed.

### On MacOS

```bash
./run.sh
```
Which displays:
```
TBD
```

## Runtime options

There are a number of options available

```
$ modelio-wrapper -h

Launch modelio using:
 modelio-wrapper [options] bash

OPTIONS:
   -c NB_CPUS                       Limit to NB_CPUS the CPU usage (default: 2.0, 0: unlimited)
   -p MODELIO_HOME                  Specify a prefix for host directories mounted inside the container (default: $HOME)
   -h                               Show this message
```

- `-c NB_CPUS`: allows controlling the number of cpus the container
  may use (docker's `--cpus` option). By default, set to
  `2.0`. Unlimited use can be specified bt passing `-c 0`.
- `-p MODELIO_HOME`: allows specifying a path under which to set the
  path of the directories used to share data between host and
  guest. By default, it will be set to $HOME, i.e. sharing directories
  `$HOME/Documents/ModelioWorkspace/` and `$HOME/.modelio/` with the
  guest. As an alternative, one may set the `MODELIO_HOME` env var.

# Maintenance

## Updating

To update to a newer release of the container image, for Modelio 5.4.1:

  1. Download the updated Docker image:

  ```bash
  docker pull olberger/docker-modelio:5.4.1
  ```

  2. Run `install` to make sure the host scripts are updated.

  ```bash
  docker run -it --rm \
    --volume /usr/local/bin:/target \
    olberger/docker-modelio:5.4.1 install
  ```

## Upgrading

To update to a release of the container image for a later version of
Modelio, check the repository's master branch instructions.

## Running previous versions

See https://github.com/olberger/docker-modelio/tree/4.1 for
instructions on running a container for Modelio 4.1.

Running multiple versions alongside in separate containers should be
possible, but test this at your own risks.

## Uninstallation

```bash
docker run -it --rm \
  --volume /usr/local/bin:/target \
  olberger/docker-modelio:5.4.1 uninstall
```

## Local image rebuild

```bash
docker build --tag  olberger/docker-modelio:5.4.1 .
```

## Run without installation

For debugging purposes, one may run directly the wrapper script
without installing it in `/usr/local/bin`.
```bash
./scripts/modelio-wrapper bash
```


# Performance issues

Due to [performance issue with GTK3](https://github.com/ModelioOpenSource/Modelio/issues/11) (or another strange Java
runtime issue), the `docker run` command launched by the wrapper limits CPU usage. On a host with 8 cores (`lscpu` command), here follows the behaviour with
some values of CPU usage:

* 1.5 (core) : too slow, unusable
* 2.0 : slow (default)
* 3.0 : convenient
* 4.0 : comfortable

Adjust the `-c` option passed to the `modelio-wraper-5.4.1`, depending on your needs.

## Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes
- Help users resolve their [issues](https://github.com/olberger/docker-modelio/issues?q=is%3Aopen+is%3Aissue).


## How it works

The wrapper scripts mounts the X11 socket in the launcher container (a Docker volume). The X11 socket allows for the user interface display on the host.

When the image is launched the following directories are mounted as volumes:

- `~/.modelio-5.4.1/`, or `${MODELIO_HOME}/.modelio-5.4.1/` if option `-p` is
  provided, or a value of `MODELIO_HOME` is defined
- `~/Documents/ModelioWorkspace/` (where `Documents` is determined
  through `XDG_DOCUMENTS_DIR`), or similarly `${MODELIO_HOME}/Documents/ModelioWorkspace/`

This makes sure that the configuration of the tool are stored on the
host and files saved are preserved in the user's home on the host, if placed inside the special 'ModelioWorkspace/' subdirectory.

**Don't want to expose standard host's folders to Modelio application?**

Either set a global `MODELIO_HOME` environment variable to namespace
all modelio folders, or use the `-p` option to the wrapper script:

```sh
mkdir -p ${HOME}/modelio-guest/
export MODELIO_HOME=${HOME}/modelio-guest
```


# Sources / inspiration

- forked from https://github.com/pascalpoizat/docker-modelio ,
  hopefully retaining the possibility to merge back
- this is a simple update from [https://github.com/GehDoc/docker-modelio](https://github.com/GehDoc/docker-modelio) with no use of the user's UID/GID
- solution to access the X11 display from [https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb](https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb)
- improved by Olivier Berger to create user at runtime and avoid rebuilding to tackle uid/gid into account, inspired by https://github.com/mdouchement/docker-zoom-us
