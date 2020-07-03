set -ex
rm -f package.json.temp
rm -f package-lock.json.temp
docker cp $(docker run -d $(docker build . -q)):/usr/local/app/package.json ./package.json.temp
docker cp $(docker run -d $(docker build . -q)):/usr/local/app/package-lock.json ./package-lock.json.temp
rm -f package.json
mv package.json.temp package.json
rm -f package-lock.json
mv package-lock.json.temp package-lock.json

