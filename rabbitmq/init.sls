include:
  - firewall
  - logstash.client

rabbitmq-server:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: rabbitmq-server
    - watch:
      - file: /etc/rabbitmq/rabbitmq.config

/etc/rabbitmq/rabbitmq.config:
  file.managed:
    - template: jinja
    - source: salt://rabbitmq/templates/rabbitmq.config


{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('rabbitmq', 5672, 'tcp') }}
{{ firewall_enable('rabbitmq', 4369, 'tcp') }}
{{ firewall_enable('rabbitmq', 45352, 'tcp') }}


{% from 'logstash/lib.sls' import logship with context %}
{{ logship('rabbitmq-logs', '/var/log/rabbitmq/*.log', 'rabbitmq', ['rabbitmq', 'log'], 'json', '\\\\n\\\\n') }}
