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

{% for pname,policy in salt['pillar.get']('rabbitmq:policies',{}).items() %}
rabbit_policy_{{ pname }}:
  rabbitmq_policy.present:
    - name: {{ pname }}
    - pattern: {{ policy.pattern }}
    - definition: '{{ policy.definition|string }}'
    - vhost: {{ policy.vhost }}
    - require:
      - service: rabbitmq-server
{% endfor %}

{% from 'firewall/lib.sls' import firewall_enable with context %}
{% if rabbitmq.management.enabled %}
rabbitmq_management:
  rabbitmq_plugin.enabled:
    - watch_in:
      service: rabbitmq-server
{% if rabbitmq.management.firewall.enabled %}
{% else %}
{{ firewall_enable('rabbitmq-management', rabbitmq.management.port, 'tcp') }}
{% endif %}
{% endif %}

{{ firewall_enable('rabbitmq-node', 5672, 'tcp') }}
{{ firewall_enable('rabbitmq-erlang-mapper', 4369, 'tcp') }}
{{ firewall_enable('rabbitmq-erlang-cluster', 25672, 'tcp') }}


{% from 'logstash/lib.sls' import logship with context %}
{{ logship('rabbitmq-logs', '/var/log/rabbitmq/*.log', 'rabbitmq', ['rabbitmq', 'log'], 'json', '\\\\n\\\\n') }}
