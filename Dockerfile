FROM elixir:latest

RUN mkdir -p /root/.ssh

WORKDIR /app

RUN ["mix", "local.hex", "--force"]
RUN ["mix", "local.rebar", "--force"]
