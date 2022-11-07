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

#ENV GEM_HOME="~/bundle"
#ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
RUN rbenv install 2.7.4
ENV rbenv global 2.7.4
RUN rbenv global 2.7.4
RUN ruby -v
#RUN apt-get -y install ruby
# SHELL ["/bin/bash", "-c"]
RUN gem install bundler -v 2.3.13
#RUN gem install bundler -v 2.3.13
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
# RUN echo 'export NVM_DIR="$HOME/.nvm"' ~/.bashrc
# RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' ~/.bashrc
# RUN echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"' ~/.bashrc
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 16.13.2

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#RUN npm install
#RUN nvm install 16.13.2
#RUN npm install yarn 1.22.19
# RUN git clone https://github.com/PyTorchKorea/hub-kr.git
RUN git clone -b preview_hub --single-branch https://github.com/cpprhtn/hub-kr.git
RUN cd /hub-kr/


# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt remove cmdtest
RUN apt remove yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#RUN apt-get install yarn -y
RUN npm install -g yarn
RUN yarn install

# RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
# RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
# RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
# #SHELL ["/bin/bash", "-c"]
# ENV locale-gen en_US.UTF-8
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
