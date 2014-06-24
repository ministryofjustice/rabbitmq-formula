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

/etc/apparmor.d/usr.lib.erlang.erts-5.8.5.bin.beam.smp:
  file.managed:
    - source: salt://rabbitmq/templates/rabbitmq_apparmor_profile
    - template: jinja
    - watch_in:
       - service: rabbitmq-server

{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('rabbitmq', 5672, 'tcp') }}
{{ firewall_enable('rabbitmq', 4369, 'tcp') }}
{{ firewall_enable('rabbitmq', 45352, 'tcp') }}


{% from 'logstash/lib.sls' import logship with context %}
{{ logship('rabbitmq-logs', '/var/log/rabbitmq/*.log', 'rabbitmq', ['rabbitmq', 'log'], 'json', '\\\\n\\\\n') }}
