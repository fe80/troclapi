FROM ruby:2.4-alpine

MAINTAINER Steffy FORT <steffyfort@gmail.com>

RUN apk add --no-cache make build-base git mysql-dev

RUN git clone https://github.com/fe80/troclapi.git /usr/src/troclapi
RUN bundle install --path vendor/bundle --gemfile=/usr/src/troclapi/Gemfile

COPY troclarc.yaml /etc/troclarc.yaml
RUN chmod 0600 /etc/troclarc.yaml

ENV BUNDLE_GEMFILE /usr/src/troclapi/Gemfile

RUN mkdir /var/log/troclapi

WORKDIR /usr/src/troclapi

EXPOSE 5678

CMD ["bundle", "exec", "/usr/src/troclapi/app.rb"]
