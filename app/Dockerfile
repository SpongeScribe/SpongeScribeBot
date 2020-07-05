# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

ARG VERSION=latest
ARG LOG_LEVEL=
ARG WORKDIR=/usr/local/app
ARG FILES='modules* appversion* babel.config*.json build*.sh entrypoint*.sh install*.sh index*.js sleep*.js twitter*.js version*.sh .babelrc*'

FROM node:$VERSION AS base
ARG LOG_LEVEL
ENV NPM_CONFIG_LOGLEVEL $LOG_LEVEL
RUN export DEBIAN_FRONTEND=noninteractive && apt update -y && apt upgrade -y
RUN ["npm", "install", "-g", "npm", "n"]
RUN ["n", "latest"]

FROM base AS dependencies
ARG WORKDIR
WORKDIR $WORKDIR
COPY package.json package*-lock.json ./
RUN ["npm", "install", "--only=prod"]
COPY *LICENSE* *READ* *CODE* *CONTRIB* ./
CMD ["/bin/bash"]

FROM dependencies AS devDependencies
RUN ["npm", "install", "--only=dev"]
RUN DEBIAN_FRONTEND=noninteractive apt install -y uuid-runtime vim

#TODO build / babell
FROM dependencies AS build
ARG BUILD_SCRIPT
COPY $FILES ./
RUN /bin/bash $BUILD_SCRIPT

FROM devDependencies AS devBuild
ARG BUILD_SCRIPT
COPY $FILES ./
RUN /bin/bash $BUILD_SCRIPT

FROM build as sleep
ENTRYPOINT ["/bin/bash", "sleep.sh"]
CMD ["10"]

FROM devBuild as dev
COPY .env .
ENTRYPOINT ["/bin/bash"]
CMD [""]

FROM devBuild as install
ENTRYPOINT ["/bin/bash", "install.sh"]
CMD ["update"]

FROM devBuild as twitter
COPY .env .
ENTRYPOINT ["/bin/bash", "twitter.sh"]
CMD ["post hello-world"]

FROM devBuild as devCopyAll
COPY . .
ENTRYPOINT ["/bin/bash"]
CMD [""]

FROM build AS deploy
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]
