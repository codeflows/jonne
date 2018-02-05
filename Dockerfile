FROM bitwalker/alpine-elixir:1.6.1 as build

COPY ./config/config.exs ./config/config.exs
COPY ./config/prod.exs ./config/prod.exs
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

FROM bitwalker/alpine-erlang:20.2.2

COPY --from=build /export/ .
USER default

EXPOSE 9001

ENTRYPOINT ["/opt/app/bin/jonne"]
CMD ["foreground"]
