
$site_name = 'Agora Voting'
$agora_fqdn = 'local.dev'
$agora_ssl_port = '9443'
$fnmt_fqdn = 'fnmt.local.dev'
$session_cookie_domain = '.local.dev'

# if activated, it will overwrite agora settings if present
$overwrite_agora_settings = 'true'

$agora_auto_join = ''
$agora_admin_username = 'agora'
$agora_admin_password = 'some password'
$agora_front_page = 'None'

$enable_varnish = 'true'

# email stuff (used in multiple places like agora and sentry..)

$server_mail = 'agora@local.dev'
$email_host = ''
$email_host_password = ''
$email_host_user = ''
$email_port = ''

$agora_auto_activation_secret = 'some secret key'

$db_password =  'some secret password'

$django_secret_key = 'some secret password'

# admin and ssh stuff

$admin_name = 'Bob Esponja'
$admin_email = 'bob@local.dev'
$ssh_authorized_keys = 'ssh-dss AAAAB3NzaC1kc3MAAACBAIeRYPgKLZvThg7foFrLzYUTD/mCAmaXjLl2WkAm9lmeQ0JoQIeujCzTYu2WsdP83ILOa0q83BXUXsUm3ylxnaQjvJ/WyWahy2ciyCccdndo+CXGcfascqqd+XGyIW/f9s/p4vNPtKrQcatvVDgonMfkNQzcsgpgUyeeMfbU50x7AAAAFQCtqfHY2ywqtZ7aasSFt8Mjbv6stQAAAIAc/oFyEyndEAaYpSUGYNxSJvd7MaUk3DY5qlmmvzkGS6rVV9f/ykullxpFKJEnAla4dcXc+WPTXdGDWvzON1mwMN+86znlxtKrZ44gy2RoAyUSXEk9fchRfJBo9lI+PrCPy8GaOuoWrLn63v9YuGovRq7sC+BgI0/Uu5LPvZQQFQAAAIBPOhzuSbz+28D01KxTxTqz6Hs75j+NAveCVsKRwJ5jQssjepNSta9MXKQ46Oxe3UdGFp8wcJgJLJYIW0C2EPWa3TVlnBzg5BNJSq/1HG2e8vD2uxF2Xx2q+9hYrSuNjv4paRYHZkLAJnspNp3Zl/LYU+TAZ81kEyEMXhUJrxe0oQ== edulix@edulix-laptop'

# sentry conf

$sentry_ssl_port = '9443'
$sentry_fqdn = 'sentry.local.dev'
$sentry_secret_key = 'some secret password'
$sentry_db_password =  'some secret'

$sentry_username = 'admin'
$sentry_userpass = 'admin pass'

# backup

$backup_password = 'backup password'

require agora
require sentry
require backup

