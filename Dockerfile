FROM ruby:2.3
MAINTAINER mo@mokhan.ca

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  unzip

RUN mkdir -p /app
WORKDIR /app

ADD Gemfile* ./
RUN gem install bundler && bundle install --jobs 4
ADD . ./
