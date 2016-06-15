Global Parameters
=================
The following are global parameters used for configuration this plugin:
* **user** - connects as this user
* **private_key** - connects with this private key
* **server** - (default: `'https://supermarket.chef.io'`) Supermarket server to connect to
* **ssl_verify** - (default: `true`) Enable/Disable SSL verify

Example
=======

### Minimal Definition
This will upload the cookbook to a supermarket server
```yaml
deploy:
  chef_supermarket:
    user: userid
    private_key: "-----BEGIN RSA PRIVATE KEY-----\nMIIasdf...\n-----END RSA PRIVATE KEY-----"
    server: https://mysupermarket.com
```
