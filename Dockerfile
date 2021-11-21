FROM elixir:1.13 AS builder

# The following are build arguments used to change variable parts of the image.
# The name of your application/release (required)
ARG APP_NAME
ARG SECRET_KEY_BASE

# ENV APP_NAME=${APP_NAME}
ENV APP_NAME=live_k8s
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# set build ENV
ENV MIX_ENV=prod

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apt-get update && \
  apt-get install -y \
    vim \
    git \
    nodejs \
    npm && \
  mix local.rebar --force && \
  mix local.hex --force

# This copies our app source code into the build container
COPY . .

RUN echo $(ls)

# Run the build
RUN mix do deps.get, deps.compile, clean, compile

# Something is wrong with glib and releases and I don't want to deal with that now
CMD ["mix", "phx.server"]