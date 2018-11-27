FROM quay.io/aptible/ubuntu:14.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-install -y npm build-essential libssl-dev curl make sudo wget apt-transport-https
RUN wget -q -O aptible-cli.deb "https://omnibus-aptible-toolbelt.s3.amazonaws.com/aptible/omnibus-aptible-toolbelt/master/176/pkg/aptible-toolbelt_0.16.1%2B20180730142041%7Eubuntu.14.04-1_amd64.deb"
RUN apt-get update
# Pegging our version of dpkg to avoid this issue: https://github.com/travis-ci/travis-ci/issues/9361
RUN apt install --only-upgrade dpkg=1.17.5ubuntu5.8 ./aptible-cli.deb