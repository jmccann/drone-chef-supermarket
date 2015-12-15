# Docker image for the Drone Chef Supermarket plugin
#
#     cd $GOPATH/src/github.com/drone-plugins/drone-chef-supermarket
#     make deps build docker

FROM alpine:3.2

RUN apk update && \
  apk add \
    ca-certificates && \
  rm -rf /var/cache/apk/*

ADD drone-chef-supermarket /bin/
ENTRYPOINT ["/bin/drone-chef-supermarket"]
