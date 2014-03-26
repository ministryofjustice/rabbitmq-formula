rabbitmq-server:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: rabbitmq-server


{% from 'logstash/lib.sls' import logship with context %}
{{ logship('rabbitmq-logs', '/var/log/rabbitmq/*.log', 'rabbitmq', ['rabbitmq', 'log'], 'json', '\\\\n\\\\n') }}
