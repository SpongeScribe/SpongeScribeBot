DOCKER_TARGET=$1
shift
docker run -it $(docker build -q app --target $DOCKER_TARGET) "$@"
