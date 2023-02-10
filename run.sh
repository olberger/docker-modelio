#!/bin/sh

xhost + 127.0.0.1

#xhost + 127.0.0.1
xhost +$(hostname)

#docker run -ti --rm -e DISPLAY=host.docker.internal:0 -v $HOME/.modelio:/home/modelio/.modelio:z -v $HOME/modelio:/home/modelio/modelio:z --net=host --ipc=host olberger/docker-modelio:5.1 bash
#docker run -ti --rm -e DISPLAY=$DISPLAY -v $HOME/.modelio:/home/modelio/.modelio:z -v $HOME/modelio:/home/modelio/modelio:z --net=host --ipc=host olberger/docker-modelio:5.1 bash
docker run -ti --rm --cpus 2.0 -e DISPLAY=host.docker.internal:0 -v $HOME/.modelio:/home/modelio/.modelio:z -v $HOME/modelio:/home/modelio/modelio:z --net=host --ipc=host olberger/docker-modelio:5.1 bash
