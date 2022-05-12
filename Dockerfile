FROM ruby:2.7.6 AS builder
WORKDIR /app
RUN gem install bundler
COPY . /app
RUN bundle update --bundler
RUN bundle exec jekyll build -d builded

FROM nginx:alpine
COPY --from=builder /app/builded /usr/share/nginx/html/