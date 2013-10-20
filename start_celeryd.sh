#!/usr/bin/env sh
cd /vagrant/agora-ciudadana
./manage.py celeryd -l INFO -B -S djcelery.schedulers.DatabaseScheduler > /tmp/agora-celeryd.log 2> /tmp/agora-celeryd.err &