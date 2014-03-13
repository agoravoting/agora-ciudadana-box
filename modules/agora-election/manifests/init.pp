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
	
	package { ['python3.3', 'python3.3-dev', 'python3-setuptools', 'flite']:
        ensure => present
    } ->
	
    # --- database -----------------------------------------------------------

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

    # --- aelection configuration installation ------------------------------------
	
	exec { 'append_virtualenvwrapper_in_profile_aelection':
        command => "echo 'source /etc/bash_completion.d/virtualenvwrapper' >> /home/aelection/.profile",
        user    => 'aelection',
        unless  => "grep 'virtualenvwrapper' -- /home/aelection/.profile"
    } ->

    file {'/var/www/aelection/':
        ensure  => directory,
        owner   => 'aelection',
        group   => 'www-data',
    } ->
	
	file { '/home/aelection/custom_settings.py':
        ensure  => file,
        owner   => 'aelection',
        content => template('agora-election/aelection_settings.py.erb'),
    } ->

    file { '/home/aelection/faq.json':
        ensure  => file,
        owner   => 'aelection',
        mode    => 'a+x',
        content => template('agora-election/faq.json.erb'),
    } ->

    file { '/home/aelection/election.json':
        ensure  => file,
        owner   => 'aelection',
        mode    => 'a+x',
        content => template('agora-election/election.json.erb'),
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

    exec{'change_owner_aelection_static':
        command   => 'chown aelection:www-data -R /var/www/aelection/static',
        user      => 'root',
        logoutput => true,
    } ->

    file { '/home/aelection/aelection_celery_launch.sh':
        ensure  => file,
        owner   => 'aelection',
        mode    => 'a+x',
        content => template('agora-election/aelection_celery_launch.sh.erb'),
    } ->

    file { '/home/aelection/update.sh':
        ensure  => file,
        mode    => 'a+x',
        owner   => 'aelection',
        content => template('agora-election/aelection_update.sh.erb'),
    } ->

    file { '/home/aelection/start.sh':
        ensure  => file,
        mode    => 'a+x',
        owner   => 'aelection',
        content => template('agora-election/start.sh.erb'),
    } ->

    file { '/home/aelection/uwsgi.ini':
        ensure  => file,
        owner   => 'aelection',
        content => template('agora-election/aelection_uwsgi.ini.erb'),
    } ->

    # --- services files -----------------------------------------------------

    file {'/etc/supervisor/conf.d/aelection.conf':
        ensure  => file,
        content => template('agora-election/supervisor_aelection.conf.erb'),
        require => Package['supervisor'],
        notify  => Service['supervisor', 'rabbitmq-server', 'postgresql'],
    } ->

    file {'/etc/supervisor/conf.d/aelection-celery.conf':
        ensure  => file,
        require => Package['supervisor'],
        content => template('agora-election/supervisor_aelection_celery.conf.erb'),
        notify  => Service['supervisor'],
    }
}