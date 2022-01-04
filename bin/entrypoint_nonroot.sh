#!/bin/sh
set -eu

EXTENSIONS="${EXTENSIONS:-none}"

eval "$(fixuid -q)"

mkdir -p /home/${USER}/workspace
mkdir -p /home/${USER}/.local/share/code-server/User
cat > /home/${USER}/.local/share/code-server/User/settings.json << EOF
{
    "workbench.colorTheme": "Visual Studio Dark"
}
EOF
chown ${USER} /home/${USER}/workspace
chown -R ${USER} /home/${USER}/.local

if [ "${DOCKER_USER-}" ]; then
  #sudo usermod --login "$DOCKER_USER" ${USER}
  #sudo groupmod -n "$DOCKER_USER" ${USER}
  USER="$DOCKER_USER"
fi

if [ ${EXTENSIONS} != "none" ]
    then
      echo "Installing Extensions"
      for extension in $(echo ${EXTENSIONS} | tr "," "\n")
        do
          if [ "${extension}" != "" ]
            then
              dumb-init /usr/bin/code-server \
                --install-extension "${extension}" \
                /home/${USER}
	  fi
        done
fi

if [ ${HTTPS_ENABLED} = "true" ]
  then
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      --cert /home/${USER}/.certs/cert.pem \
      --cert-key /home/${USER}/.certs/key.pem \
      /home/${USER}/workspace
else
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      /home/${USER}/workspace
fi
