#
# Image for Open DevOps Pipeline
#
#VERSION : 0.1
FROM jenkins

#Maintainer
MAINTAINER Open DevOps Team <open.devops@gmail.com>

#install plugin
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/plugins.sh /tmp/plugins.txt
