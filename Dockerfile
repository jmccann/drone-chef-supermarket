FROM alpine:3.3

RUN apk update && \
  apk add \
    ca-certificates \
    git \
    ruby \
    ruby-dev \
    build-base \
    perl \
    libffi-dev \
    bash && \
  gem install --no-ri --no-rdoc \
    gli \
    --version '~> 2.14' && \
  gem install --no-ri --no-rdoc \
    mixlib-shellout \
    --version '~> 2.2' && \
  gem install --no-ri --no-rdoc \
    json \
    --version '~> 2.0' && \
  gem install --no-ri --no-rdoc \
    chef \
    --version '12.10.24' && \
  gem install --no-ri --no-rdoc \
    knife-supermarket \
    --version '~> 0.2' && \
  apk del \
    bash \
    libffi-dev \
    perl && \
  rm -rf /var/cache/apk/*

COPY pkg/drone-chef-supermarket-0.0.0.gem /tmp/

RUN gem install --no-ri --no-rdoc --local \
  /tmp/drone-chef-supermarket-0.0.0.gem

ENTRYPOINT ["/usr/bin/drone-chef-supermarket", "upload"]
