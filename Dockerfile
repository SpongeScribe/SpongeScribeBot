# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
ARG VERSION=latest
ARG LOGLEVEL=
ARG WORKDIR=/usr/local/app
ARG BUILD='./scripts/build.sh'
ARG RELEASE=
ARG NODE_ENV=production
ARG MANAGER=yarn
#install|ci
ARG NPM_PROD_DEPS_COMMAND="install"
ARG YARN_DEPS='./scripts/yarnloader.sh'
ARG YARN_PROD="TRUE"
#<null>|--prod

FROM "node:$VERSION" AS base
ARG WORKDIR
# RUN mkdir -p "$WORKDIR" && chown -R node:node "$WORKDIR"
WORKDIR "$WORKDIR"
COPY ./LICENSE ./NOTICE.LICENSE.md ./README.md ./CHANGELOG.md ./CODE_OF_CONDUCT.md ./CONTRIBUTORS.md ./
RUN export DEBIAN_FRONTEND=noninteractive && apt update -y && apt upgrade -y && apt install -y uuid uuid-runtime
RUN	npm install -g npm n
RUN n latest

FROM base AS dependencies-yarn
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
# USER node
# ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
# ENV PATH=$PATH:/home/node/.npm-global/bin
# ARG YARN_DEPS
# ENV YARN_DEPS "$YARN_DEPS"
# app/scripts/$YARN_DEPS
COPY ./package.json ./.yarn*rc ./.yarnrc*.yml ./yarn*.lock ./
COPY ./.yarn/ ./.yarn/
# ARG YARN_PROD
# ENV YARN_PROD "$YARN_PROD"
# ARG NODE_ENV
# ENV NODE_ENV "$NODE_ENV"
ARG LOGLEV
ENV NPM_CONFIG_LOGLEVEL "$LOGLEVEL"
RUN if [ -s "./.yarnrc.yml" ] ; then yarn ; else yarn ; fi
# RUN	yarn up
# RUN
CMD ["/bin/bash"]

FROM base AS dependencies-npm
# USER node
# ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
# ENV PATH=$PATH:/home/node/.npm-global/bin
COPY ./package.json ./package*-lock.json ./
ARG NODE_ENV
ENV NODE_ENV "$NODE_ENV"
ARG NPM_PROD_DEPS_COMMAND
ENV NPM_PROD_DEPS_COMMAND "$NPM_PROD_DEPS_COMMAND"
RUN npm $NPM_PROD_DEPS_COMMAND --only=prod
CMD ["/bin/bash"]

FROM dependencies-yarn AS dev-dependencies-yarn
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
RUN  if [ -s "./.yarnrc.yml" ] ; then yarn up --verbose ; else yarn upgrade ; fi
# RUN ["yarn", "up", "--verbose"]
CMD ["/bin/bash"]

FROM dependencies-npm AS dev-dependencies-npm
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
RUN ["npm", "install"]
CMD ["/bin/bash"]

FROM dependencies-$MANAGER AS build
COPY ./app/scripts/build.sh ./app/scripts/entrypoint.sh ./app/scripts/install.sh ./app/scripts/sleep.sh ./app/scripts/twitter.sh ./app/scripts/twitter-autohook.sh ./app/scripts/version.sh ./scripts/
COPY ./app/modules/image-generation.js ./app/modules/sleep.js modules/
COPY ./Dockerfile ./app/index.js ./app/sleep.js ./app/twitter.js ./app/twitter-autohook.js ./app/.babelrc ./
ARG BUILD
ENV BUILD "$BUILD"
ARG RELEASE
ENV RELEASE "$RELEASE"
ARG NODE_ENV
ENV NODE_ENV "$NODE_ENV"
RUN /bin/bash "$BUILD" "$RELEASE"
CMD ["/bin/bash"]

FROM dependencies-$MANAGER AS deploy
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY --from=build "$WORKDIR/scripts/entrypoint.sh" ./
COPY --from=build "$WORKDIR/modules/image-generation.js" "$WORKDIR/modules/sleep.js" modules/
COPY --from=build "$WORKDIR/Dockerfile" "$WORKDIR/index.js" "$WORKDIR/sleep.js" "$WORKDIR/twitter.js" "$WORKDIR/.babelrc" ./
ENTRYPOINT ["/bin/bash"]
CMD ["./scripts/entrypoint.sh"]

FROM dev-dependencies-$MANAGER as twitter
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY --from=build "$WORKDIR/scripts/twitter.sh" ./scripts/
COPY --from=build "$WORKDIR/twitter.js" "$WORKDIR/VERSION" ./
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
ENTRYPOINT ["/bin/bash", "./scripts/twitter.sh"]
CMD [""]

FROM dev-dependencies-$MANAGER as twitter-autohook
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY --from=build "$WORKDIR/scripts/twitter-autohook.sh" ./scripts/
COPY --from=build "$WORKDIR/twitter-autohook.js" "$WORKDIR/VERSION" ./
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
ENTRYPOINT ["/bin/bash", "./scripts/twitter-autohook.sh"]
CMD [""]

FROM dev-dependencies-$MANAGER as sleep
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY --from=build "$WORKDIR/modules/sleep.js" modules/
COPY --from=build "$WORKDIR/scripts/sleep.sh" ./scripts/
COPY --from=build "$WORKDIR/sleep.js" "$WORKDIR/VERSION" ./
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
ENTRYPOINT ["/bin/bash", "./scripts/sleep.sh"]
CMD ["10"]

FROM sleep as install
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY --from=build "$WORKDIR/modules/sleep.js" modules/
COPY --from=build "$WORKDIR/scripts/install.sh" "$WORKDIR/scripts/version.sh" ./scripts/
ARG MANAGER
ENV MANAGER "$MANAGER"
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
ENTRYPOINT ["/bin/bash", "./scripts/install.sh"]
CMD ["up"]

FROM dev-dependencies-$MANAGER as dev
RUN DEBIAN_FRONTEND=noninteractive apt install -y vim
COPY ./app/modules/* ./modules/
COPY ./app/scripts/* ./scripts/
COPY ./Dockerfile ./package.json ./package*-lock.json ./*.json ./*.yml ./*LICENSE* ./*README* ./*NOTICE* ./*.md ./*.temp.* ./app/* ./
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
COPY --from=build "$WORKDIR/modules/*" ./modules/
COPY --from=build "$WORKDIR/Dockerfile" "$WORKDIR/*.*" "$WORKDIR/.*" ./
ARG MANAGER
ENV MANAGER "$MANAGER"
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
CMD ["/bin/bash"]

FROM deploy AS default
ENTRYPOINT ["/bin/bash"]
CMD ["./scripts/entrypoint.sh"]
