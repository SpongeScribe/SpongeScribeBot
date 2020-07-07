# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
ARG VERSION=latest
ARG LOGLEVEL=
ARG WORKDIR=/usr/local/app
ARG BUILD='./build.sh'

FROM node:$VERSION AS base
RUN export DEBIAN_FRONTEND=noninteractive && apt update -y && apt upgrade -y
RUN	npm install -g npm n
RUN n latest
ARG LOGLEV
ENV NPM_CONFIG_LOGLEVEL $LOGLEVEL
ARG WORKDIR
WORKDIR $WORKDIR

FROM base AS dependencies
COPY package.json package*-lock.json ./
RUN ["npm", "install", "--only=prod"]
COPY LICENSE NOTICE.LICENSE.md README.md CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTORS.md ./
CMD ["/bin/bash"]

FROM dependencies AS devDependencies
RUN ["npm", "install", "--only=dev"]
RUN DEBIAN_FRONTEND=noninteractive apt install -y uuid-runtime vim

FROM dependencies AS build
COPY app/scripts/build.sh app/scripts/entrypoint.sh app/scripts/install.sh app/index.js app/sleep.js app/twitter.js app/scripts/sleep.sh app/scripts/twitter.sh app/scripts/version.sh app/.babelrc ./
COPY app/modules/image-generation.js app/modules/sleep.js modules/
ARG BUILD
ENV BUILD $BUILD
RUN /bin/bash $BUILD
CMD ["/bin/bash"]

FROM devDependencies as twitter
ARG WORKDIR
ENV WORKDIR $WORKDIR
COPY --from=build $WORKDIR/package.json $WORKDIR/package-lock.json $WORKDIR/twitter.js $WORKDIR/VERSION $WORKDIR/twitter.sh ./
ENTRYPOINT ["/bin/bash", "twitter.sh"]
CMD ["post hello-world"]

FROM devDependencies as sleep
ARG WORKDIR
ENV WORKDIR $WORKDIR
COPY --from=build $WORKDIR/package.json $WORKDIR/package-lock.json $WORKDIR/sleep.js $WORKDIR/VERSION $WORKDIR/sleep.sh ./
COPY --from=build $WORKDIR/modules/sleep.js modules/
ENTRYPOINT ["/bin/bash", "sleep.sh"]
CMD ["10"]

FROM sleep as install
COPY app/scripts/install.sh ./
ENTRYPOINT ["/bin/bash", "install.sh"]
CMD ["update"]

FROM build as dev
COPY app/scripts/*.sh app/*.js app/.babelrc ./
COPY app/modules/*.js modules/
CMD ["/bin/bash"]

FROM dependencies AS deploy
ARG WORKDIR
ENV WORKDIR $WORKDIR
COPY --from=build $WORKDIR/entrypoint.sh $WORKDIR/index.js $WORKDIR/sleep.js $WORKDIR/twitter.js $WORKDIR/.babelrc ./
COPY --from=build $WORKDIR/modules/image-generation.js $WORKDIR/modules/sleep.js modules/
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]
