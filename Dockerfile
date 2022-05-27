FROM hexpm/elixir:1.13.4-erlang-25.0-rc3-alpine-3.15.3

ENV USER learn-elixir-with-tests

# we need to add git if anyone try to install a git Mix dep
RUN apk add --no-cache build-base openssl ncurses-libs git

RUN adduser -D $USER


WORKDIR /home/$USER

# Install hex and rebar
RUN mix local.hex --force --if-missing && \
    mix local.rebar --force --if-missing

# install livebook itself
RUN yes | mix escript.install hex livebook

COPY ./ /home/$USER

RUN mix deps.get
RUN mix deps.compile

# Override the default 127.0.0.1 address, so that the app
# can be accessed outside the container by binding ports
ENV LIVEBOOK_IP 0.0.0.0

RUN cp /root/.mix/escripts/livebook ./
RUN chown -R $USER .

USER $USER

CMD [ "./livebook", "server" ]
