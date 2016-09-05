[![Docker Automated buil](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg?maxAge=2592000)](https://hub.docker.com/r/devopsopen/docker-ci-jenkins/)

# CI/CD Management - Jenkins
CI jenkins Image for Open DevOps Pipeline

- Uses latest OS / TINI / Jenkins releases
- Avoid 2.0 setup wizard but provide secure-by-default configuration
- Installs default suggested plugins
- Installs Additional Useful plugins
    - [Blue Ocean](https://jenkins.io/projects/blueocean/)
- Setup Agent port

# docker-ci-jenkins
CI jenkins Image for Open DevOps Pipeline

# docker pull
docker pull devopsopen/docker-ci-jenkins

# docker run
docker run -d -p 9080:8080 --name jenkins devopsopen/docker-ci-jenkins

# web access
http://docker-host-machine-ip:9080
