# Set the ruby version
FROM ruby:2.2.0

# Install essential stuff for rails
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm

# Create the app directory
RUN mkdir /app

# Install bundler
RUN gem install bundler --no-ri --no-rdoc

# Install Rails
RUN gem install rails --no-ri --no-rdoc

# Install rake
RUN gem install rake --no-ri --no-rdoc

# Set it as the Workdir
WORKDIR /app

# Add the Gemfile
ADD Gemfile Gemfile

# Install the dependencies
RUN bundle install

# Add the source code
ADD . .
