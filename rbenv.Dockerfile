FROM debian:bookworm

RUN echo "deb http://mirror.mephi.ru/debian/ bookworm main non-free-firmware \
          deb-src http://mirror.mephi.ru/debian/ bookworm main non-free-firmware \
          deb http://security.debian.org/debian-security bookworm-security main non-free-firmware \
          deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware \
          deb http://mirror.mephi.ru/debian/ bookworm-updates main non-free-firmware \
          deb-src http://mirror.mephi.ru/debian/ bookworm-updates main non-free-firmware" >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get install git curl wget build-essential libreadline-dev libssl-dev  \
    libgdbm-dev zlib1g-dev libsass-dev libffi-dev libyaml-dev imagemagick libpq-dev cmake gpp -y
WORKDIR /ruby
RUN wget -e use_proxy=yes -e http_proxy=http://proxy:Mesina226@ru.krainovpn.ru:12346 https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.6.tar.gz
RUN tar -xzf ruby-3.2.6.tar.gz
WORKDIR /ruby/ruby-3.2.6
RUN ./configure
RUN make -j12 && make -j12 install
RUN gem install bundler
ARG NODE_VERSION=18.15.0
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master
WORKDIR /rails
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN bundle binstubs overmind

EXPOSE 9091
CMD ["bin/overmind", "start", "-f", "Procfile", "-s", "/rails/tmp/.overmind.sock"]
