FROM ruby:3.1.2-alpine3.15

MAINTAINER Steffy FORT <gem@p0l.io>

RUN apk add --no-cache make build-base openssl openssl-dev
COPY . /usr/src/troclapi
RUN bundle install --gemfile=/usr/src/troclapi/Gemfile

ENV BUNDLE_GEMFILE=/usr/src/troclapi/Gemfile \
  LANG=en_US.UTF-8

WORKDIR /usr/src/troclapi

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "/usr/src/troclapi/config.ru"]
