rabbitmq-formula
================

Some example pillar data:

```
rabbitmq:
  cluster_hosts:
    - rabbit@front-01
    - rabbit@front-02
  erlang:
    cookie: AAAAAAAAAAAAAAAAAAAA
  policies:
    HA:
      pattern: '.*'
      definition: '{"ha-mode": "all"}'
      vhost: /my-vhost
```

Note: rabbitmq doesn't support FQDNs so make sure you use short names in the cluster_hosts values and make sure they are resolvable.

## Erlang cookie
The erlang cookie should be a random string A-Z, don't use the above example.

Rabbitmq must be stopped before you change the cookie. So the salt state here will stop rabbit if it's going to change and will ensure the service is running after the change.
