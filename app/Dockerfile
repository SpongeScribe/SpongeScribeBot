# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

ARG VERSION=latest
ARG LOG_LEVEL=info
ARG WORKDIR=/usr/local/app
ARG BUILD_SCRIPT=build.sh
ARG ENTRYPOINT_SCRIPT=entrypoint.sh

FROM node:$VERSION AS base
ARG LOG_LEVEL
ENV NPM_CONFIG_LOGLEVEL $LOG_LEVEL

FROM base AS dependencies
ARG WORKDIR
WORKDIR $WORKDIR
COPY package.json package*-lock.json ./
RUN ["npm", "install"]
COPY *LICENSE* *READ* *CODE* *CONTRIB* ./
CMD ["/bin/bash"]

FROM dependencies as sleep
COPY modules/util/* modules/util/
COPY sleep*.js sleep*.sh ./
ENTRYPOINT ["/bin/bash", "sleep.sh"]
CMD ["10"]

FROM sleep as installDev
COPY install*.sh version*.sh appversion* ./
ENTRYPOINT [""]
CMD ["/bin/bash"]

FROM installDev as install
ENTRYPOINT ["/bin/bash", "install.sh"]
CMD ["update"]

FROM dependencies AS build
ARG BUILD_SCRIPT
COPY . .
RUN /bin/bash $BUILD_SCRIPT

FROM build AS deploy
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]
