{% from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
  - firewall
  - logstash.client

rabbitmq-server:
  pkg:
    - installed
    - require:
      # yes really otherwise the cluster won't start
      - file: /etc/rabbitmq/rabbitmq.config
  service:
    - running
    - enable: True
    - require:
      - pkg: rabbitmq-server
    - watch:
      - file: /etc/rabbitmq/rabbitmq.config

/etc/rabbitmq:
  file.directory

/etc/rabbitmq/rabbitmq.config:
  file.managed:
    - template: jinja
    - source: salt://rabbitmq/templates/rabbitmq.config
    - require:
      - file: /etc/rabbitmq

{% if rabbitmq.cluster_hosts %}
dead-rabbitmq-server:
  service.dead:
    - name: rabbitmq-server

/var/lib/rabbitmq/.erlang.cookie:
  file.managed:
    - user: rabbitmq
    - group: rabbitmq
    - mode: 400
    - source: salt://rabbitmq/templates/erlang.cookie
    - template: jinja
    - prereq_in:
      # we have to stop rabbit before we change this cookie
      - service: dead-rabbitmq-server
    - watch_in:
      - service: rabbitmq-server
{% endif %}

{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('rabbitmq', 5672, 'tcp') }}
{{ firewall_enable('rabbitmq', 4369, 'tcp') }}
{{ firewall_enable('rabbitmq', 45352, 'tcp') }}
{{ firewall_enable('rabbitmq', 25672, 'tcp') }}


{% from 'logstash/lib.sls' import logship with context %}
{{ logship('rabbitmq-logs', '/var/log/rabbitmq/*.log', 'rabbitmq', ['rabbitmq', 'log'], 'json', '\\\\n\\\\n') }}
