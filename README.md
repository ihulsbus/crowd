Crowd Cookbook
==============
[![Chef cookbook](https://img.shields.io/cookbook/v/crowd.svg)](https://supermarket.chef.io/cookbooks/crowd)
[![Build Status](https://travis-ci.org/afklm/crowd.svg?branch=master)](https://travis-ci.org/afklm/crowd)

This cookbook installs Atlassian's Crowd. It defaults to using PostgreSQL for
its DB and Nginx for its proxy.

It sets up a full working system after which you can run Atlassian's configuration
wizard. If you want more influence, you can write a wrapper cookbook for your
specific setup.

Supports
--------

- Ubuntu 14.04
- CentOS 6.7

Other platforms or versions may or may not work, but I've simply not tested them
at this time. If your run this cookbook on another platform or version
successfully, please let me know in GitHub issues.

Usage
-----
#### crowd::default

Just include `crowd` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[crowd]"
  ]
}
```

## Attributes

These attributes are under the `node['crowd']` namespace.

Attribute    | Description                                           | Type    | Default
-------------|-------------------------------------------------------|---------|---------------------------------------
home_path    | home directory                                        | String  | /var/atlassian/application-data/crowd
init_type    | JIRA init service type - "sysv"                       | String  | sysv
install_path | location to install                                   | String  | /opt/atlassian
install_type | Install type - currently only "standalone"            | String  | standalone
version      | Version to install                                    | String  | 2.8.3
ssl          | Whether to use SSL to secure Crowd                    | Boolean | false
user         | user running Crowd                                    | String  | crowd
group        | group running Crowd                                   | String  | crowd

These attributes are under the `node['crowd']['database']` namespace.

Attribute    | Description                                           | Type    | Default
-------------|-------------------------------------------------------|---------|---------------------------------------
type         | DB type to use - currently only postgresql            | String  | postgresql
host         | FQDN to DB machine or "localhost" for local installs  | String  | localhost
port         | DB port                                               | String  | 5432
name         | DB name                                               | String  | crowd
user         | DB user                                               | String  | crowd
password     | DB user password                                      | String  | changeit


Contributing
------------

1. Fork the repository on Github
2. Create a named feature or bug branch (like `add_component_x`)
3. Write your change
4. Write ChefSpec / ServerSpec tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Licensed under MIT, see LICENSE for details.

Authors: Martijn van der Kleijn <martijn.vanderkleijn@klm.com>
