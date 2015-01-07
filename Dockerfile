FROM jacobat/ruby:2.1.5-3

RUN apt-get update
RUN apt-get install -y build-essential libmysqlclient-dev libpq-dev libsqlite3-dev nodejs
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD . /app
RUN bundle exec rake db:migrate
CMD bundle exec rails s
