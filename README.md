# drone-chef-supermarket

[![Build Status](http://beta.drone.io/api/badges/drone-plugins/drone-chef-supermarket/status.svg)](http://beta.drone.io/drone-plugins/drone-chef-supermarket)
[![Coverage Status](https://aircover.co/badges/drone-plugins/drone-chef-supermarket/coverage.svg)](https://aircover.co/drone-plugins/drone-chef-supermarket)
[![](https://badge.imagelayers.io/plugins/drone-chef-supermarket:latest.svg)](https://imagelayers.io/?images=plugins/drone-chef-supermarket:latest 'Get your own badge on imagelayers.io')

Drone plugin to publish cookbooks to Supermarket (internal or public). For the usage information and a listing of the available options please take a look at [the docs](DOCS.md).

## Execute

Install the deps using `rake`:

```
bundle install --path=gems --retry=5 --jobs=5
```

### Example

```sh
bundle exec bin/drone-chef-supermarket <<EOF
{
    "repo": {
        "clone_url": "git://github.com/drone/drone",
        "owner": "drone",
        "name": "drone",
        "full_name": "drone/drone"
    },
    "system": {
        "link_url": "https://beta.drone.io"
    },
    "build": {
        "number": 22,
        "status": "success",
        "started_at": 1421029603,
        "finished_at": 1421029813,
        "message": "Update the Readme",
        "author": "johnsmith",
        "author_email": "john.smith@gmail.com",
        "event": "push",
        "branch": "master",
        "commit": "436b7a6e2abaddfd35740527353e78a227ddcb2c",
        "ref": "refs/heads/master"
    },
    "workspace": {
        "root": "/drone/src",
        "path": "/drone/src/github.com/drone/drone"
    },
    "vargs": {
        "user": "octocat",
        "private_key": "-----BEGIN RSA PRIVATE KEY-----\nMIIasdf...\n-----END RSA PRIVATE KEY-----",
        "server": "https://mysupermarket.com",
        "ssl_verify": false
    }
}
EOF
```

## Docker

Build the container using `rake`:

```
bundle install --path=gems --retry=5 --jobs=5
bin/rake build docker
```

### Example

```sh
docker run -i plugins/drone-chef-supermarket:latest <<EOF
{
    "repo": {
        "clone_url": "git://github.com/drone/drone",
        "owner": "drone",
        "name": "drone",
        "full_name": "drone/drone"
    },
    "system": {
        "link_url": "https://beta.drone.io"
    },
    "build": {
        "number": 22,
        "status": "success",
        "started_at": 1421029603,
        "finished_at": 1421029813,
        "message": "Update the Readme",
        "author": "johnsmith",
        "author_email": "john.smith@gmail.com",
        "event": "push",
        "branch": "master",
        "commit": "436b7a6e2abaddfd35740527353e78a227ddcb2c",
        "ref": "refs/heads/master"
    },
    "workspace": {
        "root": "/drone/src",
        "path": "/drone/src/github.com/drone/drone"
    },
    "vargs": {
        "user": "octocat",
        "private_key": "-----BEGIN RSA PRIVATE KEY-----\nMIIasdf...\n-----END RSA PRIVATE KEY-----",
        "server": "https://mysupermarket.com",
        "ssl_verify": false
    }
}
EOF
```
