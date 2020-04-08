FROM php:7-alpine as build

RUN apk add \
  libpng-dev \
  zlib-dev

WORKDIR /usr/src/php/ext

RUN pecl bundle redis \
  && docker-php-ext-configure redis --enable-redis-lzf

RUN docker-php-ext-install -j$(nproc) \
  bcmath \
  gd \
  pdo_mysql \
  redis

FROM php:7-alpine

RUN apk add --no-cache \
  libpng \
  zlib

COPY --from=build /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=build /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

WORKDIR /srv

CMD ["php", "/srv/artisan", "serve", "--host", "0.0.0.0"]

EXPOSE 8000
