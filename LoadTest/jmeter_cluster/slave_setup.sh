#!/bin/sh
curl http://apache-mirror.rbc.ru/pub/apache/jmeter/binaries/apache-jmeter-3.0.tgz > jMeter.tgz
tar zxvf jMeter.tgz

# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html
public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
allowed_port=1098
apache-jmeter-3.0/bin/jmeter-server -Djava.rmi.server.hostname=$public_ip -Dclient.rmi.localport=$allowed_port