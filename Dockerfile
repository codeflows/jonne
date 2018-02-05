FROM bitwalker/alpine-elixir:1.6.1 as build

COPY rel ./rel
COPY lib ./lib
COPY mix.exs .
COPY mix.lock .

ENV MIX_ENV=prod
ENV APP_NAME=jonne
ENV REPLACE_OS_VARS=true

RUN mix deps.get && \
    mix release

RUN RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

FROM pentacent/alpine-erlang-base:latest

COPY --from=build /export/ .
USER default

EXPOSE 9001

ENTRYPOINT ["/opt/app/bin/$APP_NAME"]
CMD ["foreground"]
