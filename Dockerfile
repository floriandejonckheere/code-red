FROM ruby:3.0-alpine

MAINTAINER Florian Dejonckheere <florian@floriandejonckheere.be>
LABEL org.opencontainers.image.source https://github.com/floriandejonckheere/code-red

ENV RUNTIME_DEPS postgresql
ENV BUILD_DEPS build-base curl-dev git postgresql-dev cmake nodejs yarn

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENV APP_HOME /app/
WORKDIR $APP_HOME/

# Add user
ARG USER=docker
ARG UID=1000
ARG GID=1000

RUN addgroup -g $GID $USER
RUN adduser -D -u $UID -G $USER -h $APP_HOME/ $USER

# Install system dependencies
RUN apk add --no-cache $BUILD_DEPS $RUNTIME_DEPS

# Install Bundler
RUN gem update --system && gem install bundler

# Install Gem dependencies
ADD Gemfile $APP_HOME/
ADD Gemfile.lock $APP_HOME/

RUN bundle install

# Add application
ADD . $APP_HOME/

RUN mkdir -p $APP_HOME/tmp/pids/

RUN chown -R $UID:$GID $APP_HOME/

# Change user
USER $USER

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
