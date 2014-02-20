class sentry() {
    Exec {
        path => ['/usr/sbin', '/usr/bin', '/usr/local/bin', '/sbin', '/bin']
    }

    user {'sentry':
        ensure     => present,
        home       => '/home/sentry',
        managehome => true,
        shell      => '/bin/bash'
    } ->

    exec { "apt_get_update2":
        command => "apt-get update"
    } ->

    # -- ssl certificate -----------------------------------------------------

    file {'/var/www/certs/sentry/':
        ensure  => directory,
        owner   => 'sentry',
        group   => 'users',
    } ->

    file { '/tmp/sentry_generate_certs.sh':
        ensure  => file,
        mode    => 'a+x',
        content => template('sentry/generate_certs.sh.erb'),
    } ->

    exec { '/tmp/sentry_generate_certs.sh':
        user      => 'sentry',
        logoutput => true,
        timeout   => 100,
    } ->

    # --- database -----------------------------------------------------------

    file { '/tmp/sentry_db_setup.sh':
        ensure  => file,
        mode    => 'a+x',
        content => template('sentry/db_setup.sh.erb'),
    } ->

    exec { '/tmp/sentry_db_setup.sh':
        user      => 'postgres',
        logoutput => true,
        unless    => "psql -l | grep '^ sentry'",
        timeout   => 10,
    } ->

    # --- setup --------------------------------------------------------------

    file { '/home/sentry/.sentry':
        ensure  => directory,
        owner   => 'sentry',
    } ->

    file { '/home/sentry/.sentry/sentry.conf.py':
        ensure  => file,
        owner   => 'sentry',
        content => template('sentry/sentry.conf.py.erb'),
    } ->

    exec { 'append_virtualenvwrapper_in_sentry_profile':
        command => "echo 'source /etc/bash_completion.d/virtualenvwrapper' >> /home/sentry/.profile",
        user    => 'sentry',
        unless  => "grep 'virtualenvwrapper' -- /home/sentry/.profile"
    } ->

    file { '/tmp/sentry_setup.sh':
        ensure  => file,
        owner   => 'sentry',
        mode    => 'a+x',
        content => template('sentry/sentry_setup.sh.erb'),
    } ->

    exec { '/tmp/sentry_setup.sh':
        user      => 'sentry',
        logoutput => true,
        timeout   => 1000,
        require   => Package['nginx', 'postgresql', 'python-pip'],
    } ->

    file { '/tmp/sentry_bootstrap.py':
        ensure  => file,
        mode    => 'a+x',
        content => template('sentry/sentry_bootstrap.py.erb'),
    } ->

    file { '/tmp/sentry_bootstrap.sh':
        ensure  => file,
        owner   => 'sentry',
        mode    => 'a+x',
        content => template('sentry/sentry_bootstrap.sh.erb'),
    } ->

    exec { '/tmp/sentry_bootstrap.sh':
        user      => 'sentry',
        logoutput => true,
        timeout   => 1000,
    } ->

    exec { "raven_config_update":
        command   => 'cat /tmp/raven_config >> /home/agora/agora-ciudadana/agora_site/custom_settings.py; rm /tmp/raven_config',
        user      => 'root',
        unless    => 'grep RAVEN_CONFIG -- /home/agora/agora-ciudadana/agora_site/custom_settings.py'
    } ->

    file { '/home/sentry/uwsgi.ini':
        ensure  => file,
        owner   => 'sentry',
        content => template('sentry/sentry_uwsgi.ini.erb'),
    } ->

    # -- service -------------------------------------------------------------

    file {'/etc/nginx/conf.d/sentry.conf':
        ensure  => file,
        content => template('sentry/nginx_sentry.conf.erb'),
        notify  => Service['nginx'],
    } ->

    file {'/etc/supervisor/conf.d/sentry.conf':
        ensure  => file,
        content => template('sentry/supervisor_sentry.conf.erb'),
        notify  => Service['supervisor'],
    }
}