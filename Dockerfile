# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

FROM node AS base
ENV NPM_CONFIG_LOGLEVEL info

FROM base AS deps
WORKDIR /usr/local/app
COPY package.json package*-lock.json ./
RUN ["npm", "install"]
COPY *LICENSE* *README* ./

FROM deps AS build
COPY * ./
RUN /bin/bash build.sh

FROM build AS deploy
ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]

