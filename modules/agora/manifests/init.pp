class agora() {
    Exec {
        path => ['/usr/sbin', '/usr/bin', '/usr/local/bin', '/sbin', '/bin']
    }

    # -- users ---------------------------------------------------------------

    user { 'agora':
        ensure     => present,
        home       => '/home/agora',
        managehome => true,
        shell      => '/bin/bash'
    } ->

    # --- packages -----------------------------------------------------------

    exec { "apt_get_update":
        command => "apt-get update"
    } ->
    package { ['curl', 'aptitude', 'git', 'vim', 'build-essential', 'rabbitmq-server', 'gettext', 'libxml2-dev', 'libxslt1-dev', 'python2.7-dev', 'virtualenvwrapper', 'postgresql', 'postgresql-server-dev-all', 'supervisor', 'pwgen', 'uwsgi', 'python-pip', 'uwsgi-plugin-python', 'openssl', 'fail2ban', 'varnish', 'memcached', 'libmemcached-dev', 'goaccess', 'libffi-dev']:
        ensure => present,
    } ->

    exec { 'add_nginx_repo':
        command => "echo 'deb http://nginx.org/packages/debian/ wheezy nginx' >> /etc/apt/sources.list; wget http://nginx.org/keys/nginx_signing.key; apt-key add nginx_signing.key; apt-get update",
        unless  => "grep 'wheezy nginx' -- /etc/apt/sources.list"
    } ->
    package { 'nginx':
        ensure => present,
    } ->

    # -- vim -----------------------------------------------------------------

    exec { 'vim_syntax_on':
        command => "echo 'syntax on' >> /etc/vim/vimrc",
        unless  => "grep '^syntax on' -- /etc/vim/vimrc",
        require => Package['vim'],
    }

    # --- services -----------------------------------------------------------

    service { 'rabbitmq-server':
        ensure => running,
        enable => true,
    }

    service { 'postgresql':
        ensure   => running,
        enable   => true,
        restart  => 'service postgresql restart',
    }

    service { 'nginx':
        ensure     => running,
        enable     => true,
        hasrestart => true,
    }

    service { 'supervisor':
        ensure     => running,
        enable     => true,
        restart    => 'supervisorctl reload',
    }

    service { 'ssh':
        ensure     => running,
        enable     => true,
        hasrestart => true,
    }

    service { 'fail2ban':
        ensure     => running,
        enable     => true,
        hasrestart => true,
    }

    service { 'memcached':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require => Package['memcached'],
    }

    service { 'varnish':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require => Package['varnish'],
    }

    # --- ssh configuration --------------------------------------------------

    file {'/root/.ssh':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '700',
    } ->

    file { '/tmp/ssh_setup.sh':
        ensure  => file,
        mode    => 'a+x',
        content => template('agora/ssh_setup.sh.erb'),
    } ->

    exec { '/tmp/ssh_setup.sh':
        user      => 'root',
        logoutput => true,
        timeout   => 100,
    } ->

    # --- database -----------------------------------------------------------

    # workaround for http://projects.puppetlabs.com/issues/4695
    # when PostgreSQL is installed with SQL_ASCII encoding instead of UTF8
    exec { 'utf8 postgres':
        command => 'pg_dropcluster --stop 9.1 main ; pg_createcluster --start --locale en_US.UTF-8 9.1 main',
        user    => 'postgres',
        unless  => 'psql -t -c "\l" | grep template1 | grep -q UTF',
    } ->

    file { '/tmp/db_setup.sh':
        ensure  => file,
        mode    => 'a+x',
        content => template('agora/db_setup.sh.erb'),
    } ->
    exec { '/tmp/db_setup.sh':
        user      => 'postgres',
        logoutput => true,
        unless    => "psql -l | grep '^ agora'",
        timeout   => 10,
    } ->

    # -- ssl certificate -----------------------------------------------------

    file {'/var/www/':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        recurse => true,
    } ->

    file {'/var/www/certs/':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        recurse => true,
    } ->

    file {'/var/www/certs/agora/':
        ensure  => directory,
        owner   => 'agora',
        group   => 'users',
        recurse => true,
    } ->

    file {'/var/www/certs/fnmt/':
        ensure  => directory,
        owner   => 'agora',
        group   => 'users',
        recurse => true,
    } ->

    file { '/usr/bin/crypt.pl':
        ensure  => file,
        owner   => 'root',
        mode    => 'a+x',
        content => template('agora/crypt.pl.erb'),
    } ->

    file { '/tmp/generate_certs.sh':
        owner => 'root',
		ensure  => file,
        mode    => 'a+x',
        content => template('agora/generate_certs.sh.erb'),
    } ->

    file { '/usr/bin/eopeers':
        ensure  => file,
        owner   => 'root',
        mode    => 'a+x',
        content => template('agora/eopeers.erb'),
    } ->

	file { '/usr/bin/eopeers.py':
        ensure  => file,
        owner   => 'root',
        mode    => 'a+x',
        content => template('agora/eopeers.py.erb'),
    } ->

    exec { '/tmp/generate_certs.sh':
        user      => 'root',
        logoutput => true,
        timeout   => 100,
    } ->

    # --- agora configuration nstallation ------------------------------------

    exec { 'append_virtualenvwrapper_in_profile':
        command => "echo 'source /etc/bash_completion.d/virtualenvwrapper' >> /home/agora/.profile",
        user    => 'agora',
        unless  => "grep 'virtualenvwrapper' -- /home/agora/.profile"
    } ->

    file { '/home/agora/custom_settings.py':
        ensure  => file,
        owner   => 'agora',
        content => template('agora/custom_settings.py.erb'),
    } ->

    file {'/var/www/agora/':
        ensure  => directory,
        owner   => 'agora',
        group   => 'www-data',
        recurse => true,
    } ->

    file {'/var/www/agora/static/':
        ensure  => directory,
        owner   => 'agora',
        group   => 'www-data',
        recurse => true,
    } ->

    file { '/tmp/install_npm.sh':
        ensure  => file,
        owner   => 'agora',
        mode    => 'a+x',
        content => template('agora/install_npm.sh.erb'),
    } ->

    exec { '/tmp/install_npm.sh':
        user      => 'root',
        logoutput => true,
        creates   => '/usr/local/bin/npm',
        timeout   => 3000,
    } ->

    file { '/tmp/agora_setup.sh':
        ensure  => file,
        owner   => 'agora',
        mode    => 'a+x',
        content => template('agora/agora_setup.sh.erb'),
    } ->

    exec { '/tmp/agora_setup.sh':
        user      => 'agora',
        logoutput => true,
        creates   => '/home/agora/agora-ciudadana',
        require => Package['virtualenvwrapper', 'libmemcached-dev', 'gettext'],
        timeout   => 3000,
    } ->

    file { '/home/agora/update.sh':
        ensure  => file,
        mode    => 'a+x',
        owner   => 'agora',
        content => template('agora/agora_update.sh.erb'),
    } ->

    file { '/home/agora/uwsgi.ini':
        ensure  => file,
        owner   => 'agora',
        content => template('agora/agora_uwsgi.ini.erb'),
    } ->

    file { '/home/agora/agora_celery_launch.sh':
        ensure  => file,
        owner   => 'agora',
        mode    => 'a+x',
        content => template('agora/agora_celery_launch.sh.erb'),
    } ->

    file {'/home/agora/agoraprivate/':
        ensure  => directory,
        owner   => 'agora',
        recurse => true,
    } ->

    file {'/var/www/agora/media/':
        ensure  => directory,
        owner   => 'agora',
        group   => 'www-data',
        recurse => true,
    } ->

    file {'/var/www/agora/media/dnis/':
        ensure  => directory,
        owner   => 'agora',
        group   => 'www-data',
    } ->

    # --- services files -----------------------------------------------------

    file {'/etc/nginx/nginx.conf':
        ensure  => file,
        content => template('agora/nginx.conf.erb'),
        notify  => Service['nginx'],
        require => Package['nginx'],
    } ->

    file {'/etc/nginx/conf.d/agora.conf':
        ensure  => file,
        content => template('agora/nginx_agora.conf.erb'),
        notify  => Service['nginx'],
    } ->

    file {'/etc/supervisor/conf.d/agora.conf':
        ensure  => file,
        content => template('agora/supervisor_agora.conf.erb'),
        notify  => Service['supervisor', 'rabbitmq-server', 'postgresql'],
    } ->

    file {'/etc/supervisor/conf.d/agora-celery.conf':
        ensure  => file,
        content => template('agora/supervisor_agora_celery.conf.erb'),
        notify  => Service['supervisor'],
    }

    # -- fail2ban conf -------------------------------------------------------

    file { '/etc/fail2ban/filter.d/nginx-limitreq.conf':
        ensure  => file,
        content => template('agora/fail2ban/nginx-limitreq.conf.erb'),
        require => Package['fail2ban'],
    } ->
    file { '/etc/fail2ban/filter.d/w00tw00t.conf':
        ensure  => file,
        content => template('agora/fail2ban/w00tw00t.conf.erb'),
    } ->

    file { '/etc/fail2ban/filter.d/nginx-http-auth.conf':
        ensure  => file,
        content => template('agora/fail2ban/nginx-http-auth.conf.erb'),
    } ->

    file { '/etc/fail2ban/jail.conf':
        ensure  => file,
        content => template('agora/fail2ban/jail.conf.erb'),
        notify  => Service['fail2ban'],
    }

    # -- varnish conf --------------------------------------------------------

    file { '/etc/varnish/default.vcl':
        ensure  => file,
        content => template('agora/varnish/default.vcl.erb'),
        require => Package['varnish'],
        notify  => Service['varnish'],
    }
}
