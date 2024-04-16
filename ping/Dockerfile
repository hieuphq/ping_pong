FROM elixir:1.14.3-alpine AS builder

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add make g++ git openssl libtool python3 py3-pip yaml-dev ca-certificates

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /build

ENV MIX_ENV=prod

# Cache elixir deps
ADD . .
RUN mix deps.get
RUN mix phx.digest
RUN mix release && \
    mkdir -p /opt/build && \
    cp -r _build/prod/rel/ping /opt/build

FROM alpine:3.18.5

ARG APP_NAME=ping
ENV APP_NAME=$APP_NAME

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add bash openssl libtool yaml-dev curl ca-certificates libstdc++

WORKDIR /opt/${APP_NAME}

# Copy the OTP binary and assets deps from the build step
COPY --from=builder /opt/build/${APP_NAME} /opt/${APP_NAME}

# Create a non-root user
RUN adduser -D ${APP_NAME}app && chown -R ${APP_NAME}app: /opt/${APP_NAME}
USER ${APP_NAME}app

# Use REPLACE_OS_VARS=true in order to swap runtime env values in rel/vm.args
ENV REPLACE_OS_VARS=true

# Do not use CMD, leads to issues receiving SIGTERM properly
ENTRYPOINT ["/opt/ping/bin/ping"]

CMD ["start"]