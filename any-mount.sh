DOCKER_TARGET=$1
shift
docker run -v $PWD/data/in:/usr/local/app/data/in -v $PWD/data/out:/usr/local/app/data/out -it $(docker build -q app --target $DOCKER_TARGET) "$@"
