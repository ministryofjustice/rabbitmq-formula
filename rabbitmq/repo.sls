pivotal-software-repository:
  pkgrepo.managed:
      - name: deb http://www.rabbitmq.com/debian testing main
      - file: /etc/apt/sources.list.d/pivotal-software.list
      - key_url: salt://rabbitmq/files/pivotal-software.key
