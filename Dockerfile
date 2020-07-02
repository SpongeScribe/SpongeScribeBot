# Copyright 2020 Drewry Pope
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

FROM node AS base
ENV NPM_CONFIG_LOGLEVEL info

FROM base as install
RUN ["npm","install","text2png"]
COPY text2png.js .
RUN printf "node=$(node -v)\nnpm=$(npm -v)\napp=$(cat appversion)\n" > version;cat version
