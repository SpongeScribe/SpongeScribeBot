# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

ARG VERSION=latest
ARG LOG_LEVEL=
ARG WORKDIR=/usr/local/app
ARG BUILD_SCRIPT=build.sh
ARG ENTRYPOINT_SCRIPT=entrypoint.sh
FROM node:$VERSION AS base
ARG LOG_LEVEL
ENV NPM_CONFIG_LOGLEVEL $LOG_LEVEL
RUN export DEBIAN_FRONTEND=noninteractive && apt update -y && apt upgrade -y
RUN ["npm", "install", "-g", "npm", "n"]
RUN ["n", "latest"]
RUN ["npm", "install", "--only=prod"]

FROM base AS dependencies
ARG WORKDIR
WORKDIR $WORKDIR
COPY package.json package*-lock.json ./
COPY *LICENSE* *READ* *CODE* *CONTRIB* ./
CMD ["/bin/bash"]

FROM dependencies AS build
ARG BUILD_SCRIPT
COPY . .
RUN /bin/bash $BUILD_SCRIPT

FROM build AS devDependencies
RUN ["npm", "install", "--only=dev"]
RUN DEBIAN_FRONTEND=noninteractive apt install -y uuid-runtime vim

FROM devDependencies as sleepDev
COPY modules/util/* modules/util/
COPY sleep*.js sleep*.sh ./
ENTRYPOINT ["/bin/bash", "sleep.sh"]
CMD ["10"]

FROM sleepDev as dev
COPY install*.sh version*.sh appversion* ./
ENTRYPOINT [""]
CMD ["/bin/bash"]

FROM dev as install
ENTRYPOINT ["/bin/bash", "install.sh"]
CMD ["update"]

FROM dev as twitter
ENTRYPOINT ["/bin/bash", "twitter.sh"]
CMD ["post hello-world"]

FROM build AS deploy
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]
