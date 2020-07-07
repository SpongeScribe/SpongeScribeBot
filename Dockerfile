# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

ARG VERSION=latest
ARG LOGLEV=
ARG WORKDIR=/usr/local/app
ARG BUILD='./build.sh'

FROM node:$VERSION AS base
ARG LOGLEV
ENV NPM_CONFIG_LOGLEVEL $LOGLEV
RUN export DEBIAN_FRONTEND=noninteractive && apt update -y && apt upgrade -y
RUN	npm install -g npm n
RUN n latest

FROM base AS dependencies
ARG WORKDIR
WORKDIR $WORKDIR
COPY app/package.json app/package*-lock.json ./
RUN ["npm", "install", "--only=prod"]
COPY LICENSE LICENSE.NOTIFY.md README.md CODE_OF_CONDUCT.md CONTRIBUTORS.md ./
CMD ["/bin/bash"]

FROM dependencies AS devDependencies
RUN ["npm", "install", "--only=dev"]
RUN DEBIAN_FRONTEND=noninteractive apt install -y uuid-runtime vim

FROM dependencies AS build
COPY app/modules ./app/scripts/build.sh ./app/scripts/entrypoint.sh ./app/scripts/install.sh ./app/index.js ./app/sleep.js ./app/twitter.js ./app/scripts/version.sh ./app/.babelrc ./
ARG BUILD
RUN /bin/bash $BUILD

FROM devDependencies AS devBuild
ARG BUILD
COPY app/modules ./app/scripts/*.sh ./app/*.js ./app/.babelrc ./
RUN /bin/bash $BUILD

FROM build as sleep
ENTRYPOINT ["/bin/bash", "sleep.sh"]
CMD ["10"]

FROM devBuild as dev
CMD ["/bin/bash"]

FROM devBuild as devInstall
ENTRYPOINT ["/bin/bash", "install.sh"]
CMD ["update"]

FROM devBuild as devTwitter
ENTRYPOINT ["/bin/bash", "twitter.sh"]
CMD ["post hello-world"]

FROM devBuild as devCopyAll
COPY . .
CMD ["/bin/bash"]

FROM build AS deploy
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]
