## x.y.z (pending)

## 1.2.0

* Use JDK 8 by default
* Make Crowd PID location configurable
* Added support for MySQL - thanks wolf31o2
* Added ability to set database type to `hsqldb` or `none` for a no-op.
  [[GH-14]](https://github.com/afklm/crowd/issues/14)
* Slight tweaks to ark usage to standardize with Jira/Confluence
  cookbooks.[[GH-13]](https://github.com/afklm/crowd/issues/13)
* Pin ohai version due to incompatibility from nginx-proxy cookbook

## 1.1.3

* Add Crowd 2.8.4 support
* Loosen Postgresql cookbook requirement
* Fix rubocop issues

## 1.1.1

* Add auto-tuning for Postgresql
* Remove some unused attributes
* Move Crowd versions and checksums from attributes to library
* Add a few more tests and docs

## 1.0.0

* Rename chef_crowd -> crowd to reflect supermarket namespace change

## 0.1.2

* Fix permissions issue for property files
* Add dependency on build-essential

## 0.1.1

* Remove generation of crowd.cfg.xml
* Use correct attribute for Crowd URL generation

## 0.1.0

* Initial release of chef_crowd
