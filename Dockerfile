FROM node AS base
ENV NPM_CONFIG_LOGLEVEL info

FROM base as install
RUN ["npm","install","text2png"]
COPY text2png.js .
RUN printf "node=$(node -v)\nnpm=$(npm -v)\napp=$(cat appversion)\n" > version;cat version