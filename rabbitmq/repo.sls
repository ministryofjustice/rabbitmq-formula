pivotal-software-repository:
  pkgrepo.managed:
      - name: deb https://dl.bintray.com/rabbitmq/debian trusty main
      - file: /etc/apt/sources.list.d/pivotal-software.list
      - key_url: salt://rabbitmq/files/rabbitmq-release-signing-key.asc
