# Nginx Proxy Server

This stack configuration will deploy Nginx Proxy Manager using Docker Swarm. 

## Install service

Clone this repository in the location you want to store the service files.

```bash
git clone https://github.com/rubenqba/application-stacks
cd nginx-proxy-manager
```
[https://gist.github.com/rubenqba/13092928231c7b6872c6acf81fa566db](gist)
or you can just clone the specific `nginx-proxy-manager` directory (using this 
[gist](https://gist.github.com/rubenqba/13092928231c7b6872c6acf81fa566db)).

Then we need to create a couple of data directories to store service data and LetsEncrypt configurations:

```bash
mkdir -p {data,acme}
```

Now you can deploy the NPM using the install scripts provided or the Docker Compose file.

### Using docker stack file

To deploy the service using the stack configuration follow next steps:

```bash
BASE_DIR=$(pwd) docker stack deploy --compose-file=nginx-proxy.stack.yml lb
```

To uninstall the service just execute:

```bash
docker stack rm lb && docker wait $(docker ps -f "name=lb_proxy" -q)
docker volume rm nginx-data nginx-acme
```

### Using shell script

To deploy the service using the script just execute:

```bash
bash install.sh
```

To uninstall the service just execute:

```bash
bash uninstall.sh
```

If you have any issue using this scripts, check the file `.install.log` in current directory for debug.

## Running

After the service initialization completes, you can access the administration here http://localhost:81

