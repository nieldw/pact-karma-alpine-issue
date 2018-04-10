# Step: Install modules
# This order of steps is necessary for build caching
FROM node:6.11-alpine as modules
WORKDIR /build
COPY package.json .
COPY package-lock.json .
RUN npm install 2> /dev/null

# Step: Run tests
FROM rastasheep/alpine-node-chromium:6-alpine as tests
WORKDIR /build
COPY --from=modules /build/node_modules node_modules/
ARG TEAMCITY_VERSION
COPY . /build/

# Try to run pact-standalone in this version of alpine linux:
# https://github.com/pact-foundation/pact-ruby-standalone/wiki/Using-the-pact-ruby-standalone-with-Alpine-Linux-Docker
RUN apk add --no-cache --virtual build-dependencies build-base bash
RUN ./node_modules/@angular/cli/bin/ng test