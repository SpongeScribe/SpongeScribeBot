# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
ARG VERSION=latest
ARG LOGLEVEL=
ARG WORKDIR=/usr/local/app
ARG BUILD='./build.sh'
ARG RELEASE=

FROM "node:$VERSION" AS base
ARG WORKDIR
WORKDIR "$WORKDIR"
COPY LICENSE NOTICE.LICENSE.md README.md CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTORS.md ./
RUN export DEBIAN_FRONTEND=noninteractive && apt update -y && apt upgrade -y
RUN	npm install -g npm n
RUN n latest
ARG LOGLEV
ENV NPM_CONFIG_LOGLEVEL "$LOGLEVEL"

FROM base AS dependencies
COPY package.json package*-lock.json ./
RUN ["npm", "install", "--only=prod"]
RUN DEBIAN_FRONTEND=noninteractive apt install -y uuid-runtime
CMD ["/bin/bash"]

FROM dependencies AS devDependencies
RUN ["npm", "install", "--only=dev"]
RUN DEBIAN_FRONTEND=noninteractive apt install -y vim
CMD ["/bin/bash"]

FROM dependencies AS build
COPY Dockerfile app/scripts/build.sh app/scripts/entrypoint.sh app/scripts/install.sh app/index.js app/sleep.js app/twitter.js app/twitter.autohook.js app/scripts/sleep.sh app/scripts/twitter.sh app/scripts/version.sh app/.babelrc ./
COPY app/modules/image-generation.js app/modules/sleep.js modules/
ARG BUILD
ENV BUILD "$BUILD"
ARG RELEASE
ENV RELEASE "$RELEASE"
RUN /bin/bash "$BUILD" "$RELEASE"
CMD ["/bin/bash"]

FROM devDependencies as twitter
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY --from=build "$WORKDIR/twitter.js" "$WORKDIR/twitter.autohook.js" "$WORKDIR/twitter.sh" "$WORKDIR/VERSION" ./
ENTRYPOINT ["/bin/bash", "twitter.sh"]
CMD ["post hello-world"]

FROM devDependencies as sleep
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY --from=build "$WORKDIR/modules/sleep.js" modules/
COPY --from=build "$WORKDIR/sleep.js" "$WORKDIR/sleep.sh" "$WORKDIR/VERSION" ./
ENTRYPOINT ["/bin/bash", "sleep.sh"]
CMD ["10"]

FROM sleep as install
COPY app/scripts/install.sh ./
ENTRYPOINT ["/bin/bash", "install.sh"]
CMD ["update"]

FROM devDependencies as dev
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY app/modules/* modules/
COPY Dockerfile package.json package*-lock.json *.json *.yml *LICENSE* *README* *NOTICE* *.md *.temp.* app/* app/scripts/* ./
COPY --from=build "$WORKDIR/*.*" "$WORKDIR/.*" ./
COPY --from=build "$WORKDIR/modules/*" ./modules/
CMD ["/bin/bash"]

FROM dependencies AS deploy
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY --from=build "$WORKDIR/Dockerfile" "$WORKDIR/entrypoint.sh" "$WORKDIR/index.js" "$WORKDIR/sleep.js" "$WORKDIR/twitter.js" "$WORKDIR/.babelrc" ./
COPY --from=build "$WORKDIR/modules/image-generation.js" "$WORKDIR/modules/sleep.js" modules/
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]
