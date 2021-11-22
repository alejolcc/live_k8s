FROM elixir:1.12.3 AS builder

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

# This copies our app source code into the build container
COPY . .

# This step installs all the build tools we'll need
RUN apt-get update && \
  apt-get install -y \
    vim \
    git \
    nodejs \
    npm && \
  mix local.rebar --force && \
  mix local.hex --force


# Run the build
RUN mix do deps.get, deps.compile, clean, compile

# Run the release
RUN \
  mkdir -p /opt/built && \
  mix release --overwrite && \
  mv _build/prod/rel/live_k8s /opt/built

#
# Production docker image
#

# From this line onwards, we're in a new image, which will be the image used in production
FROM elixir:1.12.3 AS runtime

# Copy all the origin files
WORKDIR /opt/app
COPY --from=builder /opt/app .

ENV MIX_ENV=prod

# Set the workdir and copy the released app from the builder container into the production container.
WORKDIR /opt/live_k8s
COPY --from=builder /opt/built/live_k8s .

# Copy the docker entrypoint which is not part of the app release into the production container.
COPY --from=builder /opt/app/entrypoint.sh .
RUN chmod +x ./entrypoint.sh

# Launch the app
CMD ["./entrypoint.sh"]