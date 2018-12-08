## 1.4.0 (2018-12-08)

* Added checksums for most Crowd versions from `2.0.0` -> `3.3.0`
* Default version is now `3.3.0`

## 1.3.0 (2018-11-04)

* Prevented java version 'comparison of Fixnum with String failed' error ([#20](https://github.com/katbyte/chef-crowd/isues/16))
* Support for Ubuntu `16.04` ([#18](https://github.com/katbyte/chef-crowd/isues/18))
* Added checksums fo `2.8.8`, `2.9.5`, `2.10.1` ([#16](https://github.com/katbyte/chef-crowd/isues/16))
* Crowd `3.0.1` compatibility ([#22](https://github.com/katbyte/chef-crowd/isues/22))

## 1.2.2 (2016-11-02)

* Forgot the prefix crowd-home in crowd-init.properties

## 1.2.1 (2016-11-02)

* Pin ohai to below `4.0.0` due to incompatibility from nginx-proxy cookbook

## 1.2.0 (2016-11-02)

* Use JDK `8` by default
* Make Crowd PID location configurable
* Added support for MySQL - thanks wolf31o2
* Added ability to set database type to `hsqldb` or `none` for a no-op. ([#14](https://github.com/katbyte/chef-crowd/isues/14))
* Slight tweaks to ark usage to standardize with Jira/Confluence ([#13](https://github.com/katbyte/chef-crowd/isues/13))
* Pin ohai version due to incompatibility from nginx-proxy cookbook

## 1.1.3 (2016-04-19)

* Add Crowd `2.8.4` support
* Loosen Postgresql cookbook requirement
* Fix rubocop issues

## 1.1.3 (2015-12-17)

Compress certain mimetypes by default in Crowd's Tomcat

## 1.1.1 (2015-12-15)

* Add auto-tuning for Postgresql
* Remove some unused attributes
* Move Crowd versions and checksums from attributes to library
* Add a few more tests and docs

## 1.0.0 (2015-10-1)

* Rename chef_crowd -> crowd to reflect supermarket namespace change

## 0.1.2

* Fix permissions issue for property files
* Add dependency on build-essential

## 0.1.1

* Remove generation of crowd.cfg.xml
* Use correct attribute for Crowd URL generation

## 0.1.0

* Initial release of chef_crowd
