ARG RUBY_VERSION=2.7.4

FROM ruby:${RUBY_VERSION}-slim-buster

ENV RAILS_ROOT /var/www/imp
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile

COPY Gemfile.lock Gemfile.lock

COPY package.json package.json

COPY yarn.lock yarn.lock

RUN apt-get update && \
    apt-get install build-essential -y --no-install-recommends \
    vim \
    git \
    gnupg2 \
    curl \
    wget \
    nodejs \
    patch \
    ruby-dev \
    zlib1g-dev \
    liblzma-dev \
    libmariadb-dev

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn --no-install-recommends -y

ENV BUNDLER_PATH=/bundle BUNDLE_BIN=/bundle/bin GEM_HOME=/bundle

ENV PATH="${BUNDLE_BIN}:${PATH}"

ARG BUNDLER_VERSION=2.1.4

RUN gem install bundler:${BUNDLER_VERSION}

COPY . .
RUN bundle install --path=${BUNDLER_PATH}

RUN yarn install --check-files

COPY docker/app/*.sh /scripts/

RUN chmod a+x /scripts/*.sh

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
