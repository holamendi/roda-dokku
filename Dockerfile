FROM ruby:3.4.8-alpine AS builder

ENV RACK_ENV=production

RUN apk add --no-cache build-base nodejs npm

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock .ruby-version ./

RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN bundle exec vite build

FROM ruby:3.4.8-alpine

ENV RACK_ENV=production

RUN apk add --no-cache tzdata && \
    addgroup -S deploy && adduser -S deploy -G deploy

WORKDIR /usr/src/app

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /usr/src/app/public/vite /usr/src/app/public/vite

COPY --chown=deploy:deploy . .

USER deploy

#EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
