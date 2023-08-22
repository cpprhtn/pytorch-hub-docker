#docker attach ubuntu_server
FROM ubuntu:22.04
#SHELL ["/bin/bash", "-c -l"]
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN export LC_ALL="en_US.UTF-8"
RUN export LANG="en_US.UTF-8"

RUN apt-get update && apt-get upgrade -y
RUN apt -y install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile # or /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
ENV PATH /root/.rbenv/versions/2.7.4/bin:$PATH

RUN rbenv install 2.7.4
ENV rbenv global 2.7.4
RUN rbenv global 2.7.4
RUN ruby -v
RUN gem install bundler -v 2.3.13
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 16.13.2

# install nvm
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN git clone -b preview_hub --single-branch https://github.com/cpprhtn/hub-kr.git
RUN cd /hub-kr/


RUN apt remove cmdtest
RUN apt remove yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN npm install -g yarn
RUN yarn install


RUN apt-get install -y locales
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8

# Install needed default locale for Makefly
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN export LC_ALL="en_US.UTF-8"
RUN export LANG="en_US.UTF-8"

WORKDIR /hub-kr/
CMD ["./preview_hub.sh"]

EXPOSE 50001
