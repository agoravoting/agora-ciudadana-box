class backup() {
    file { '/usr/bin/create_backup.sh':
        ensure  => file,
        mode    => 'a+x',
        content => template('backup/create_backup.sh.erb'),
    } ->

    file { '/root/.backup_password':
        ensure  => file,
        mode    => '0600',
        owner   => 'root',
        content => template('backup/backup_password.erb'),
    } ->

    file { '/usr/bin/restore_backup.sh':
        ensure  => file,
        mode    => 'a+x',
        content => template('backup/restore_backup.sh.erb'),
    }
}