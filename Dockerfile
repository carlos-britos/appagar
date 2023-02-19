FROM ruby:2.7.5

# Install node & yarn
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Install base deps or additional (e.g. tesseract)
RUN apt-get update -qq \
  && apt-get install -y build-essential libpq-dev git \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

# Install deps with bundler
RUN mkdir /app
WORKDIR /app
COPY Gemfile* /app/

ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

RUN gem install bundler:2.3.14
RUN bundle install --jobs 10 --retry=3 \
  && rm -rf /usr/local/bundle/cache/* \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete
COPY . /app/

# Compile assets
ARG RAILS_ENV=development
RUN if [ "$RAILS_ENV" = "production" ]; then SECRET_KEY_BASE=$(rake secret) bundle exec rake assets:precompile; fi
