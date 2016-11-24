# v1.4.1

* Update key details

## Version 1.3.0
* Depend on `erlang-formula` and setup Pivotal Software repository to
  install packages provided by them over these available by default
  in Debian/Ubuntu (which tend to be rather old).

## Version 1.2.1
* Make cluster partition handling customisable. Set default to autoheal.

## Version 1.2.0
* Add support for admin web interface.
* Tidy up policies, include in map.jinja.

## Version 1.1.0

* Add config for clustering
* Add support for policies in the pillar

## Version 1.0.2

* Add missing requirement on firewall formula - don't assume it is included from elsewhere
* Add missing include on logstash.client for logship macro

## Version 1.0.1

* Open ports in firewall

## Version 1.0.0

* Initial Release
