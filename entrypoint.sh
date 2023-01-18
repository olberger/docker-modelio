#!/bin/bash

# Docker entrypoint which will create the user and setup runtime env

set -e

#set -x

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}

MODELIO_USER=modelio

install_modelio() {
  echo "Installing modelio-wrapper..."
  install -m 0755 /var/cache/modelio/modelio-wrapper /target/
  echo "Installing modelio..."
  ln -sf modelio-wrapper /target/modelio
}

uninstall_modelio() {
  echo "Uninstalling modelio-wrapper..."
  rm -rf /target/modelio-wrapper
  echo "Uninstalling modelio..."
  rm -rf /target/modelio
}

create_user() {
  # create group with USER_GID
  if ! getent group ${MODELIO_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${MODELIO_USER} >/dev/null 2>&1
  fi

  # create user with USER_UID
  if ! getent passwd ${MODELIO_USER} >/dev/null; then
    adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
      --gecos 'Modelio' ${MODELIO_USER} >/dev/null 2>&1
  fi
  chown ${MODELIO_USER}:${MODELIO_USER} -R /home/${MODELIO_USER}
  adduser ${MODELIO_USER} sudo >/dev/null 2>&1
}

grant_access_to_video_devices() {
  for device in /dev/video*
  do
    if [[ -c $device ]]; then
      VIDEO_GID=$(stat -c %g $device)
      VIDEO_GROUP=$(stat -c %G $device)
      if [[ ${VIDEO_GROUP} == "UNKNOWN" ]]; then
        VIDEO_GROUP=modeliovideo
        groupadd -g ${VIDEO_GID} ${VIDEO_GROUP}
      fi
      usermod -a -G ${VIDEO_GROUP} ${MODELIO_USER}
      break
    fi
  done
}

launch_bash() {
    cd /home/${MODELIO_USER}
#    echo 'PATH="${PATH}:/modelio/Modelio 4.1/"' > /home/${MODELIO_USER}/.bashrc
    
#  exec sudo -HEu ${MODELIO_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" xcompmgr -c -l0 -t0 -r0 -o.00 &
#  exec sudo -HEu ${MODELIO_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" $@
  #exec sudo -HEu ${MODELIO_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" /bin/bash
  exec sudo -HEu ${MODELIO_USER} /bin/bash
}

echo "Inside the running container..."
case "$1" in
  install)
    install_modelio
    ;;
  uninstall)
    uninstall_modelio
    ;;
  *|bash)
    create_user
    #grant_access_to_video_devices
    #echo "$1"
    echo "You can now launch Modelio by invoking '/usr/bin/modelio-open-source5.1' at the bash prompt, and quit with 'exit' at the end."
    launch_bash $@
    ;;
  # *)
  #   exec $@
  #;;
esac

# Never displayed cause of exec
#echo "Terminating the container..."
