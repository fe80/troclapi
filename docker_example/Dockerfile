FROM ruby:2.4-alpine

MAINTAINER Steffy FORT <steffy.fort@fr.clara.net>

RUN apk add --no-cache make build-base git mysql-dev

RUN git clone -b develop https://git.adm.fr.clara.net/sfort/troclapi.git /usr/src/troclapi
RUN bundle install --path vendor/bundle --gemfile=/usr/src/troclapi/Gemfile

COPY troclarc.yaml /etc/troclarc.yaml
RUN chmod 0600 /etc/troclarc.yaml

ENV BUNDLE_GEMFILE /usr/src/troclapi/Gemfile

WORKDIR /usr/src/troclapi

EXPOSE 5678

CMD ["bundle", "exec", "rackup", "/usr/src/troclapi/config.ru"]
