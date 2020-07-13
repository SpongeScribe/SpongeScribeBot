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
ARG MODULE_ROOT="./modules"
ARG APP="sleep-atomic"
ARG APP_PATH="$MODULE_ROOT/$APP"
#<null>|--prod

FROM "node:$VERSION" AS base
ARG WORKDIR
ENV WORKDIR "$WORKDIR"
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
ARG APP_PATH
ENV APP_PATH "$APP_PATH"
COPY $APP_PATH/package.json $APP_PATH/.yarn*rc $APP_PATH/.yarnrc*.yml $APP_PATH/yarn*.lock ./
COPY $APP_PATH/.yarn/ ./.yarn/
# ARG YARN_PROD
# ENV YARN_PROD "$YARN_PROD"
# ARG NODE_ENV
# ENV NODE_ENV "$NODE_ENV"
ARG LOGLEV
ENV NPM_CONFIG_LOGLEVEL "$LOGLEVEL"
RUN if [ -s "$APP_PATH/.yarnrc.yml" ] ; then yarn ; else yarn ; fi
# RUN	yarn up
# RUN
CMD ["/bin/bash"]

FROM base AS dependencies-npm
# USER node
# ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
# ENV PATH=$PATH:/home/node/.npm-global/bin
ARG APP_PATH
ENV APP_PATH "$APP_PATH"
COPY $APP_PATH/package.json $APP_PATH/package*-lock.json ./
ARG NODE_ENV
ENV NODE_ENV "$NODE_ENV"
ARG NPM_PROD_DEPS_COMMAND
ENV NPM_PROD_DEPS_COMMAND "$NPM_PROD_DEPS_COMMAND"
RUN npm $NPM_PROD_DEPS_COMMAND --only=prod
CMD ["/bin/bash"]

FROM dependencies-yarn AS dev-dependencies-yarn
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
RUN if [ -s "./.yarnrc.yml" ] ; then yarn up --verbose ; else yarn upgrade ; fi
CMD ["/bin/bash"]

FROM dependencies-npm AS dev-dependencies-npm
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
RUN ["npm", "install"]
CMD ["/bin/bash"]

FROM dependencies-$MANAGER AS build
COPY $APP_PATH/scripts/build.sh $APP_PATH/scripts/entrypoint.sh $APP_PATH/scripts/install.sh $APP_PATH/scripts/sleep.sh $APP_PATH/scripts/twitter.sh $APP_PATH/scripts/twitter-autohook.sh $APP_PATH/scripts/version.sh ./scripts/
COPY ./Dockerfile $APP_PATH/server.js ./
ARG BUILD
ENV BUILD "$BUILD"
ARG RELEASE
ENV RELEASE "$RELEASE"
RUN /bin/bash "$BUILD" "$RELEASE"
CMD ["/bin/bash"]

FROM dependencies-$MANAGER AS cmd
COPY --from=build "$WORKDIR/scripts/entrypoint.sh" ./scripts/
COPY --from=build "$WORKDIR/Dockerfile" "$WORKDIR/server.js" ./
ENTRYPOINT ["/bin/bash"]
CMD ["./scripts/entrypoint.sh"]

FROM cmd as entrypoint
ENTRYPOINT ["/bin/bash", "./scripts/entrypoint.sh"]
CMD [""]

FROM dev-dependencies-$MANAGER as install
COPY --from=build "$WORKDIR/scripts/install.sh" "$WORKDIR/scripts/version.sh" ./scripts/
ARG MANAGER
ENV MANAGER "$MANAGER"
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
ENTRYPOINT ["/bin/bash", "./scripts/install.sh"]
CMD ["up"]

FROM dev-dependencies-$MANAGER as dev
RUN DEBIAN_FRONTEND=noninteractive apt install -y vim
COPY ./modules/ ./modules/
# COPY ./scripts/ ./scripts/
COPY ./Dockerfile $APP_PATH/package.json $APP_PATH/package*-lock.json $APP_PATH/*.json $APP_PATH/*.yml ./*LICENSE* ./*README* ./*NOTICE* $APP_PATH/*.md ./*.md $APP_PATH/*.temp* ./*.temp.* ./
COPY --from=build "$WORKDIR/Dockerfile" "$WORKDIR/*.*" "$WORKDIR/.*" ./
ARG MANAGER
ENV MANAGER "$MANAGER"
ARG NODE_ENV_DEV
ENV NODE_ENV "$NODE_ENV_DEV"
ENTRYPOINT ["/bin/bash"]
CMD [""]

FROM entrypoint AS default
ENTRYPOINT ["/bin/bash"]
CMD ["./scripts/entrypoint.sh"]
