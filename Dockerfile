FROM alpine:3.2
RUN apk update
RUN apk upgrade
RUN apk add bash
# Install ruby and ruby-bundler
RUN apk add ruby ruby-io-console ruby-bundler
# Clean APK cache
RUN rm -rf /var/cache/apk/*

RUN mkdir /usr/app
WORKDIR /usr/app
COPY . /usr/app
