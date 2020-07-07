DOCKER_TARGET=$1
shift
docker run -it $(docker build -q . --target $DOCKER_TARGET) "$@"
