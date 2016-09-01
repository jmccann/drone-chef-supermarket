## Config
The following are global parameters used for configuration this plugin:
* **user** - connects as this user
* **server** - (default: `'https://supermarket.chef.io'`) Supermarket server to connect to
* **ssl_verify** - (default: `true`) Enable/Disable SSL verify

### Secrets
The following secret values can be set to configure the plugin.

* **SUPERMARKET_PRIVATE_KEY** - The private key of the **user** to authenticate with

It is highly recommended to put the **SUPERMARKET_PRIVATE_KEY** into secrets so it is not exposed to users. This can be done using the [drone-cli](http://readme.drone.io/0.5/reference/cli/overview/).

```
drone secret add --image=jmccann/drone-chef-supermarket \
  octocat/hello-world SUPERMARKET_PRIVATE_KEY @/path/to/keyfile
```

Then sign and commit the YAML file after all secrets are added.

```
drone sign octocat/hello-world
```

See [secrets](http://readme.drone.io/0.5/usage/secrets/) for additional information on secrets

Examples
========

### Minimal Definition
This will upload the cookbook to supermarket server https://supermarket.chef.io using `jsmith`.
```yaml
pipeline:
  chef_supermarket:
    image: jmccann/drone-chef-supermarket
    user: jsmith
```

This will upload the cookbook to supermarket server https://mysupermarket.corp.com using `jsmith`.
```yaml
pipeline:
  chef_supermarket:
    image: jmccann/drone-chef-supermarket
    server: https://mysupermarket.corp.com
    ssl_verify: false
    user: jsmith
```
