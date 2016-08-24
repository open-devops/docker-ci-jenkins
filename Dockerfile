#
# Image for Open DevOps Pipeline
#
#VERSION : 0.1
FROM jenkins

#Maintainer
MAINTAINER Open DevOps Team <open.devops@gmail.com>

#for admin user
#COPY basic-security.groovy /var/jenkins_home/init.groovy.d

#install plugin
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/plugins.sh /tmp/plugins.txt
