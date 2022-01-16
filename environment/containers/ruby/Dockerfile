FROM ruby:3.1-alpine as base_image

RUN apk update && apk add --no-cache \
    build-base \
    tzdata \
    libpq-dev

WORKDIR /app
COPY ./application/Gemfile /app/Gemfile
COPY ./application/Gemfile.lock /app/Gemfile.lock
RUN bundle check || bundle install

FROM base_image as developemnt
COPY ./environment/containers/ruby/entrypoints/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 4000