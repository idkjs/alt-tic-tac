FROM node:latest
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update && \
     apt-get install esl-erlang -y  && \
     apt-get install elixir -y && \
     mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez && \
     mix local.hex --force && \
     mix local.rebar --force && \
     npm install -g nodemon

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
EXPOSE 4000