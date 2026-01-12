FROM buildpack-deps:bookworm

RUN groupadd -r node && useradd -r -g node node

RUN echo "deb http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bookworm-updates main" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security bookworm-security main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y libleveldb-dev libsodium-dev

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 8.10.0

RUN apt-get install curl libc6 libcurl4 zlib1g libtool autoconf

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
ENV NVM_DIR $HOME/.nvm
RUN . $HOME/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
COPY package-lock.json /usr/src/app/
RUN . $HOME/.nvm/nvm.sh && npm i
COPY . /usr/src/app

EXPOSE 80
EXPOSE 8008
EXPOSE 8007

CMD . $HOME/.nvm/nvm.sh && npm start
