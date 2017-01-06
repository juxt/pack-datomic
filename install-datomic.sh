#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

apt-get install unzip

mkdir /datomic
cd /datomic

apt-get update
apt-get -y install default-jre
apt-get -y install default-jdk

wget --http-user=$DATOMIC_USER --http-password=$DATOMIC_PASSWORD "https://my.datomic.com/repo/com/datomic/datomic-pro/$DATOMIC_VERSION/datomic-pro-$DATOMIC_VERSION.zip" -O "datomic-pro-$DATOMIC_VERSION.zip"
unzip "datomic-pro-$DATOMIC_VERSION.zip"
mv "datomic-pro-$${DATOMIC_VERSION}" datomic-pro
