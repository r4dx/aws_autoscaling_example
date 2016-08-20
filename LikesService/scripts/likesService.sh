#!/bin/sh
cd /usr/local/likesService/
nohup java -Dlogging.config=conf/logback.xml -jar likesService.jar&
echo $! > /var/run/likesService.pid