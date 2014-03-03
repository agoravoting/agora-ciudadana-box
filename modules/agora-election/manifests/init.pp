class agora-election {
	
	Exec {
        path => ['/usr/sbin', '/usr/bin', '/usr/local/bin', '/sbin', '/bin']
    }

    # -- users ---------------------------------------------------------------

	user { 'aelection':
        ensure     => present,
        home       => '/home/aelection',
        managehome => true,
        shell      => '/bin/bash'
    } ->

	
	# --- packages -----------------------------------------------------------
	exec { "/bin/echo 'deb http://http.us.debian.org/debian testing main contrib non-free' >> /etc/apt/sources.list":
		unless => "grep 'deb http://http.us.debian.org/debian testing main contrib non-free' /etc/apt/sources.list 2>/dev/null"
	} ->
	
	exec { "apt-get update":		
	} ->
	
	package { ['python3.3', 'python3.3-dev', 'python3-setuptools', 'postgresql', 'postgresql-server-dev-all', 'virtualenvwrapper', 'libmemcached-dev', 'supervisor', 'rabbitmq-server']:
        ensure => present
    } ->
	
    # --- database -----------------------------------------------------------

    # already done in agora
	# workaround for http://projects.puppetlabs.com/issues/4695
    # when PostgreSQL is installed with SQL_ASCII encoding instead of UTF8
    # exec { 'utf8 postgres':
    #    command => 'pg_dropcluster --stop 9.1 main ; pg_createcluster --start --locale en_US.UTF-8 9.1 main',
    #    user    => 'postgres',
    #    unless  => 'psql -t -c "\l" | grep template1 | grep -q UTF',
    #} ->

    file { '/tmp/aelection_db_setup.sh':
        ensure  => file,
        mode    => 'a+x',
        content => template('agora-election/aelection_db_setup.sh.erb'),
    } ->
    exec { '/tmp/aelection_db_setup.sh':
        user      => 'postgres',
        logoutput => true,
        unless    => "psql -l | grep '^ aelection'",
        timeout   => 10,
		require => Package['postgresql']
    } ->
	
	# --- services -----------------------------------------------------------
	
	service { 'rabbitmq-server':
        ensure => running,
        enable => true,
    } ->
	
	service { 'postgresql':
        ensure   => running,
        enable   => true,
        restart  => 'service postgresql restart',
    } ->
	
	service { 'supervisor':
        ensure     => running,
        enable     => true,
        restart    => 'supervisorctl reload',
    } ->

    # -- ssl certificate -----------------------------------------------------

    #file { '/tmp/generate_certs.sh':
    #    ensure  => file,
    #    mode    => 'a+x',
    #    content => template('agora/generate_certs.sh.erb'),
    #} ->

    #exec { '/tmp/generate_certs.sh':
    #    user      => 'agora',
    #    logoutput => true,
    #    timeout   => 100,
    #} ->

    # --- aelection configuration installation ------------------------------------
	
	exec { 'append_virtualenvwrapper_in_profile_aelection':
        command => "echo 'source /etc/bash_completion.d/virtualenvwrapper' >> /home/aelection/.profile",
        user    => 'aelection',
        unless  => "grep 'virtualenvwrapper' -- /home/aelection/.profile"
    } ->
	
	file { '/home/aelection/settings.py':
        ensure  => file,
        owner   => 'aelection',
        content => template('agora-election/aelection_settings.py.erb'),
    } ->
	
	file { '/tmp/aelection_setup.sh':
        ensure  => file,
        owner   => 'aelection',
        mode    => 'a+x',
        content => template('agora-election/aelection_setup.sh.erb'),
    } ->

    exec { '/tmp/aelection_setup.sh':
        user      => 'aelection',
        logoutput => true,
        creates   => '/home/aelection/agora-election',
        require => Package['virtualenvwrapper', 'libmemcached-dev'],
        timeout   => 3000,
    } ->

    file { '/home/aelection/aelection_celery_launch.sh':
        ensure  => file,
        owner   => 'aelection',
        mode    => 'a+x',
        content => template('agora-election/aelection_celery_launch.sh.erb'),
    } ->

    # --- services files -----------------------------------------------------

    #file {'/etc/nginx/nginx.conf':
    #    ensure  => file,
    #    owner   => 'agora',
    #    content => template('agora/nginx.conf.erb'),
    #    notify  => Service['nginx'],
    #    require => Package['nginx'],
    #} ->

    #file {'/etc/nginx/conf.d/agora.conf':
    #    ensure  => file,
    #    content => template('agora/nginx_agora.conf.erb'),
    #    notify  => Service['nginx'],
    #} ->

    file {'/etc/supervisor/conf.d/aelection.conf':
        ensure  => file,
        content => template('agora-election/supervisor_aelection.conf.erb'),
        notify  => Service['supervisor', 'rabbitmq-server', 'postgresql'],
    } ->

    file {'/etc/supervisor/conf.d/aelection-celery.conf':
        ensure  => file,
        content => template('agora-election/supervisor_aelection_celery.conf.erb'),
        notify  => Service['supervisor'],
    }
}