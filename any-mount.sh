DOCKER_TARGET=$1
shift
docker run -v $PWD/appdata/in:/usr/local/app/data/in -v $PWD/appdata/out:/usr/local/app/data/out -it $(docker build -q app --target $DOCKER_TARGET) "$@"
