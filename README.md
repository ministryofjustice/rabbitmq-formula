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

##Admin web interface
You can enable the rabbit management interface on port 8080 with the following pillar.

Be careful with this, especially if you have the default guest user enabled. The following will enable the management interface and disable the local firewall.

```
rabbitmq:
  management:
    enabled: True
    firewall:
      enabled: False
```

##Cluster partition handling
This set to autoheal by default (a good option for two nodes and for prioritising uptime). You may want [pause_minority](https://www.rabbitmq.com/partitions.html#which-mode) if you care about data consistency and have 3 or more nodes. e.g.
```
rabbitmq:
  cluster:
    partition_handling: pause_minority
```

##Adding rabbitmq-server users
By default rabbitmq-server is set up with a guest user and only has access via localhost. To add new users with permissions on vhosts
```
rabbitmq:
  users:
    rabbit_user:
      tags:
        - administrator
      perms:
        - '/':
          - '.*'
          - '.*'
          - '.*'
      force: True
      runas: root
```
[View this page](https://docs.saltstack.com/en/develop/ref/states/all/salt.states.rabbitmq_user.html) for more info on tags.