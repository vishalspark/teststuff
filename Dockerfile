FROM quay.io/aptible/ubuntu:14.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-install -y npm build-essential libssl-dev curl make sudo wget apt-transport-https

# Pegging our version of dpkg to avoid this issue: https://github.com/travis-ci/travis-ci/issues/9361
RUN wget -q -O aptible-cli.deb "https://omnibus-aptible-toolbelt.s3.amazonaws.com/aptible/omnibus-aptible-toolbelt/master/176/pkg/aptible-toolbelt_0.16.1%2B20180730142041%7Eubuntu.14.04-1_amd64.deb"
RUN dpkg -i ./aptible-cli.deb
RUN sudo apt-get install aptible-toolbelt

# Log in to aptible using the Spark-E user
RUN aptible login --email support@trialspark.com --password "GE&mfDXKvK2N,qyHwjs4xFhsNtciQrHX" --lifetime "1 day"

# Extract the latest backup ID
RUN backup_id=$(aptible backup:list spark-staging-1 | head -n 1 | awk '{ print $1; }' | sed 's/:$//'

# Make handle name
RUN backup_handle=$(date +"%Y%m%d%H%M%S")
RUN backup_handle+="_spark-staging-1"

# Restore the latest backup
RUN echo "Restoring backup $backup_id to $backup_handle"
RUN aptible backup:restore $backup_id --handle=$backup_handle