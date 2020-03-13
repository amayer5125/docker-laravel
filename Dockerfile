FROM php:7-alpine as build

RUN apk add \
  libpng-dev \
  zlib-dev

RUN docker-php-ext-install -j$(nproc) \
  bcmath \
  gd \
  pdo_mysql

FROM php:7-alpine

RUN apk add --no-cache \
  libpng \
  zlib

COPY --from=build /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=build /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

WORKDIR /srv

CMD ["php", "/srv/artisan", "serve", "--host", "0.0.0.0"]

EXPOSE 8000
