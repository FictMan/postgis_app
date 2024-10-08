# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config libproj-dev proj-bin

# Upgrade RubyGems and install latest Bundler
RUN gem update --system && \
    gem install bundler

# Install application gems
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Store Bundler settings in the project's root
ENV BUNDLE_APP_CONFIG=.bundle

# Create a directory for the rails code
RUN mkdir -p /rails
WORKDIR /rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
