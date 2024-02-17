FROM ruby:2.1-wheezy
#FROM ruby:2.3-jessie
#FROM ruby:2.4-jessie

ENV RAILS_ROOT /var/www/sudoku

WORKDIR $RAILS_ROOT

COPY Gemfile* ./

RUN bundle config set --local without 'development test'
RUN bundle install --jobs 20 --retry 5

COPY . .

ENV PORT 3000
EXPOSE 3000
