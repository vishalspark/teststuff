FROM quay.io/aptible/ubuntu:14.04

USER vishal

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-install -y npm build-essential libssl-dev curl make sudo wget apt-transport-https

# Pegging our version of dpkg to avoid this issue: https://github.com/travis-ci/travis-ci/issues/9361
RUN wget -q -O aptible-cli.deb "https://omnibus-aptible-toolbelt.s3.amazonaws.com/aptible/omnibus-aptible-toolbelt/master/176/pkg/aptible-toolbelt_0.16.1%2B20180730142041%7Eubuntu.14.04-1_amd64.deb"
RUN dpkg -i ./aptible-cli.deb
RUN sudo apt-get install aptible-toolbelt
