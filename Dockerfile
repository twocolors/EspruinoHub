FROM node:12-alpine AS build

RUN set -x \
  && apk add --no-cache --virtual .build-deps \
    build-base \
    linux-headers \
    eudev-dev \
    python \
    git \
  && git clone https://github.com/espruino/EspruinoHub /tmp/espruinohub \
  && cd /tmp/espruinohub \
  && npm i --production --verbose \
  && apk del .build-deps \
  && mkdir /app \
  && mv /tmp/espruinohub/node_modules \
    /tmp/espruinohub/lib \
    /tmp/espruinohub/index.js \
    /tmp/espruinohub/config.json \
    /tmp/espruinohub/www \
    /tmp/espruinohub/log \
    /app/ \
  && rm -rf /tmp/*

FROM node:12-alpine

COPY --from=build /app /app

RUN set -x \
  && apk add --no-cache tzdata

VOLUME /app/log

WORKDIR /app

CMD [ "node", "index.js", "-c", "/data/config.json" ]
