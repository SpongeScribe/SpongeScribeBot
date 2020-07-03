docker cp $(docker run -d $(docker build . -q) $1; sleep 1):/usr/local/app/out.png ./out.png
