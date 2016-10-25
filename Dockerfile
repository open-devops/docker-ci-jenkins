#
# Jenkins Docker Image for Open DevOps Pipeline
#
# VERSION : 1.0
#
FROM devopsopen/docker-base

MAINTAINER Open DevOps Team <open.devops@gmail.com>

ENV REFRESHED_AT 2016-09-09

# Runtime environment settings
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

# Build arguments setting
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN addgroup -g ${gid} ${group} \
    && adduser -h "$JENKINS_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user}

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

ENV TINI_VERSION 0.10.0
ENV TINI_SHA 7d00da20acc5c3eb21d959733917f6672b57dabb

# Use tini as subreaper in Docker container to adopt zombie processes
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha1sum -c -

COPY tcp-slave-agent-port.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
COPY setup-security-control.groovy /usr/share/jenkins/ref/init.groovy.d/setup-security-control.groovy

# jenkins version being bundled in this docker image
ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.27}

# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=63a9d2f3616744b6258da83c65a19ea17283bc1f

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
    && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha1sum -c -

ENV JENKINS_UC https://updates.jenkins.io
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# Install Maven
ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV MAVEN_HOME /usr/share/maven
ENV JENKINS_MAVEN_CONFIG "$MAVEN_HOME/conf"

RUN mkdir -p /usr/share/maven /usr/share/maven/ref $MAVEN_CONFIG \
    && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
       | tar -xzC /usr/share/maven --strip-components=1 \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY mvn-settings-docker.xml $MAVEN_CONFIG/settings.xml
RUN /usr/local/bin/mvn-entrypoint.sh \
    && cp -f $MAVEN_CONFIG/settings.xml $JENKINS_MAVEN_CONFIG/settings.xml \
    && chown -R ${user} "$MAVEN_HOME"

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

USER ${user}

COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh

# Install jenkins plugins
COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# Execute jenkins services
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
