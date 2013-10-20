#!/usr/bin/env sh
cd /vagrant/agora-ciudadana
./manage.py runserver 0.0.0.0:8000 > /tmp/agora-server.log 2> /tmp/agora-server.err &