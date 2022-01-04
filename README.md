# docker-vscode-server

Docker vscode server

## About

This project is built for [github.com/bekkerlabs](https://github.com/bekkerlabs) which provides you with a environment of your choice, accessible via a web-based vscode.

The main idea is, for example, if you want to learn mysql and python, the service will provision a environment with the required dependencies, and accessible via a web-based vscode with the markdown formatted labs to follow.

In vscode your workspace folder by default will be opened in `/home/coder/workspace` and you can use your host user inside the container by passing the `--user` flag and using the `DOCKER_USER` environment variable.

## Usage

You can either build it yourself or use my dockerhub images.

The password is controlled by using the environment variable `PASSWORD`, if its not set, the password value will be in `~/.config/code-server/config.yaml`

### Build

Building:

```bash
$ docker buildx build --platform linux/amd64,linux/arm64 \
  --push --tag pbicskei/vscode-server:latest \
  --build-arg USER=${USER} \
  --build-arg UID=${UID} \
  --build-arg GID=${GID} .
```

Running with no extensions, using http and port 8080:

```bash
$ docker run -it \
  -e PASSWORD=password \
  -e DOCKER_USER=${USER} \
  -p 8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/${USER}/workspace \
  -v $PWD/config:/home/${USER}/.config \
  pbicskei/vscode-server:latest
```

Same thing

```bash
docker run -d \                     
  --env PASSWORD=password \
  --env DOCKER_USER=${USER} \
  --publish 8080:8080 \
  --user "$(id -u):$(id -g)" \
  --volume $PWD/workspace:/home/${USER}/workspace \
  --volume $PWD/config:/home/${USER}/.config \
  pbicskei/vscode-server:latest
  ```

Running with no extensions, using https and port 8443 (see [docs/minica](https://github.com/pbicskei/docker-vscode-server/blob/main/docs/minica.md) to generate certs for local use):

```bash
$ docker run -it \
  -e PASSWORD=password \
  -e HTTPS_ENABLED=true \
  -e APP_PORT=8443 \
  -e DOCKER_USER=${USER} \
  -p 8443:8443 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  -v $PWD/certs/cert.pem:/home/coder/.certs/cert.pem \
  -v $PWD/certs/key.pem:/home/coder/.certs/key.pem \
  pbicskei/vscode-server:latest
```

Running with extensions, using http and port 8080:

```bash
$ docker run -it \
  -e PASSWORD=password \
  -e DOCKER_USER=${USER} \
  -e EXTENSIONS="ms-python.python,tushortz.python-extended-snippets,andyyaldoo.vscode-json,golang.go,redhat.vscode-yaml,vscode-icons-team.vscode-icons"
  -p 8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  pbicskei/vscode:default
```

### Dockerhub Images

Running with no extensions, using http and port 8080:

```bash
$ docker run -it \
  -e PASSWORD=password \
  -e DOCKER_USER=${USER} \
  -p 8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  pbicskei//vscode-server:latest
```

Running with no extensions, using https and port 8443 (see [docs/minica](https://github.com/pbicskei/docker-vscode-server/blob/main/docs/minica.md) to generate certs for local use):

```bash
$ docker run -it \
  -e PASSWORD=password \
  -e HTTPS_ENABLED=true \
  -e APP_PORT=8443 \
  -e DOCKER_USER=${USER} \
  -p 8443:8443 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  -v $PWD/certs/cert.pem:/home/coder/.certs/cert.pem \
  -v $PWD/certs/key.pem:/home/coder/.certs/key.pem \
  pbicskei/vscode-server:latest
```

Running with extensions, using http and port 8080:

```bash
$ docker run -it \
  -e PASSWORD=password \
  -e DOCKER_USER=${USER} \
  -e EXTENSIONS="ms-python.python,tushortz.python-extended-snippets,andyyaldoo.vscode-json,golang.go,redhat.vscode-yaml,vscode-icons-team.vscode-icons"
  -p 8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  pbicskei/vscode-server:latest
```

### Persistence 

If you would like to persist your containers storage to your host for vscode's data, you can persist the follwing directories:

* `-v $PWD/config:/home/coder/.config` (configuration)
* `-v $PWD/userdata:/home/coder/.local` (logs, extensions, vscode settings, etc)

## Docker Hub

- [pbicskei/vscode-server](https://hub.docker.com/r/pbicskei/vscode-server)
