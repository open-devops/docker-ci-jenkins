[![Docker Automated buil](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg?maxAge=2592000)](https://hub.docker.com/r/devopsopen/docker-ci-jenkins/)

# CI/CD Management - Jenkins
CI jenkins Image for Open DevOps Pipeline

- Use latest OS / TINI / Jenkins releases
- Avoid 2.0 setup wizard but provide secure-by-default configuration
- Install default suggested plugins
- Install Additional Useful plugins
    - [Blue Ocean](https://jenkins.io/projects/blueocean/)
    - [Docker Pipeline Plugin](https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Docker+Pipeline+Plugin)
- Setup Agent port

# docker-ci-jenkins
CI jenkins Image for Open DevOps Pipeline

# docker pull
docker pull devopsopen/docker-ci-jenkins

# docker run
docker run -d -p 8080:8080  -p 50000:50000 --name jenkins devopsopen/docker-ci-jenkins

# web access
http://docker-host-machine-ip:8080
