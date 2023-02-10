#!/bin/sh

# Check https://gist.github.com/paul-krohn/e45f96181b1cf5e536325d1bdee6c949 and adjust the followin script until it works. Pull requests welcome

#xhost + 127.0.0.1
xhost +$(hostname)

#docker run -ti --rm -e DISPLAY=host.docker.internal:0 -v $HOME/.modelio:/home/modelio/.modelio:z -v $HOME/modelio:/home/modelio/modelio:z --net=host --ipc=host olberger/docker-modelio:4.1 bash
#docker run -ti --rm -e DISPLAY=$DISPLAY -v $HOME/.modelio:/home/modelio/.modelio:z -v $HOME/modelio:/home/modelio/modelio:z --net=host --ipc=host olberger/docker-modelio:4.1 bash
docker run -ti --rm --cpus 2.0 -e DISPLAY=host.docker.internal:0 -v $HOME/.modelio:/home/modelio/.modelio:z -v $HOME/modelio:/home/modelio/modelio:z --net=host --ipc=host olberger/docker-modelio:4.1 bash
