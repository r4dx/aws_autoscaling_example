#!/bin/sh
curl http://apache-mirror.rbc.ru/pub/apache/jmeter/binaries/apache-jmeter-3.0.tgz > jMeter.tgz
tar zxvf jMeter.tgz
apache-jmeter-3.0/bin/jmeter-server