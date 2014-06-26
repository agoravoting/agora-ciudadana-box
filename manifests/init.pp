##### General settings

# Will be used for the title in index.html of agora election
# Will also be used for SMS (SITE_NAME in agora election and agora ciudadana)
# Used for self signed certificates
$site_name = 'Agora Voting'

# Global domain for agora election/agora ciudadana
$agora_fqdn = 'local.dev'

# Specify the domain against which the cookie is set
# the default value is such that the cookie is set accross all domains (in case
# fnmt is used to authenticate on fnmt subdomain)
$session_cookie_domain = '.local.dev'

# admin and ssh stuff

# django admin name and email for agora ciudadana, agora election
# (https://docs.djangoproject.com/en/dev/ref/settings/#admins)
# also used to set git config
$admin_name = 'Bob Esponja'
$admin_email = 'bob@local.dev'

# public keys added to authorized keys to allow ssh login
$ssh_authorized_keys = 'ssh-dss AAAAB3NzaC1kc3MAAACBAIeRYPgKLZvThg7foFrLzYUTD/mCAmaXjLl2WkAm9lmeQ0JoQIeujCzTYu2WsdP83ILOa0q83BXUXsUm3ylxnaQjvJ/WyWahy2ciyCccdndo+CXGcfascqqd+XGyIW/f9s/p4vNPtKrQcatvVDgonMfkNQzcsgpgUyeeMfbU50x7AAAAFQCtqfHY2ywqtZ7aasSFt8Mjbv6stQAAAIAc/oFyEyndEAaYpSUGYNxSJvd7MaUk3DY5qlmmvzkGS6rVV9f/ykullxpFKJEnAla4dcXc+WPTXdGDWvzON1mwMN+86znlxtKrZ44gy2RoAyUSXEk9fchRfJBo9lI+PrCPy8GaOuoWrLn63v9YuGovRq7sC+BgI0/Uu5LPvZQQFQAAAIBPOhzuSbz+28D01KxTxTqz6Hs75j+NAveCVsKRwJ5jQssjepNSta9MXKQ46Oxe3UdGFp8wcJgJLJYIW0C2EPWa3TVlnBzg5BNJSq/1HG2e8vD2uxF2Xx2q+9hYrSuNjv4paRYHZkLAJnspNp3Zl/LYU+TAZ81kEyEMXhUJrxe0oQ== edulix@edulix-laptop'


##### Agora Ciudadana Settings

# if activated, puppet will overwrite agora settings if present
# leave as 'true' unless running puppet multiple times to prevent overwrite
# of agora settings
$overwrite_agora_settings = 'true'

# Agora ciudadana port (use of 9443 to not clash with 443 used for agora
# election in a combined setup)
$agora_ssl_port = '9443'

# Agoras array into which users will be automatically joined
# eg "'edulix/agora_one','edulix/agora_two'"
# can be empty string
$agora_auto_join = ''

# User/password for automatically created admin user
$agora_admin_username = 'agora'
$agora_admin_password = '<PASSWORD>'

# Used to show an Agora in the front page
# eg 'edulix/agora_one'
# Can be 'None' in which case no Agora is shown
$agora_front_page = 'None'

# agora ciuadana secret key, used to:
# allow agora election to cast votes via tokens
# allows automatic creation of users when sending voting emails
$agora_auto_activation_secret = '<PASSWORD>'

# Controls whether varnish is enabled, two locations:
# nginx configuration
# agora control of ESI to populate the ajax_data through varnish
$enable_varnish = 'false'

# agora postgresql database password
$db_password =  '<PASSWORD>'

# agora ciudadana django secret key
$django_secret_key = '<PASSWORD>'

# agora admin mode port
# used when enable_aelection is true
$agora_backend_ssl_port = '9444'

##### Agora FNMT Settings

# Activates fnmt certificate authentication
$enable_fnmt = 'false'

# Subdomain used to authenticate user with certificate (then redirected to agora
# ciudadana)
$fnmt_fqdn = 'fnmt.local.dev'


##### Email stuff (used in multiple places like agora ciudadana agora
# election and sentry..)

# FROM field used when sending messages
$server_email = 'agora@local.dev'

# email server
$email_host = ''
$email_host_password = ''
$email_host_user = ''
$email_port = ''


##### Sentry conf

# sentry port and fqdn to set nginx config
$sentry_ssl_port = '9443'
$sentry_fqdn = 'sentry.local.dev'

# sentry django secret key
$sentry_secret_key = '<PASSWORD>'

# sentry postgresql database password
$sentry_db_password =  '<PASSWORD>'

# sentry login data
$sentry_username = 'admin'
$sentry_userpass = '<PASSWORD>'


##### Backup

# gpg password used to encrypt backup data
$backup_password = '<PASSWORD>'


##### Aelection

# controls whether aelection is enabled:
# controls puppet deploy (see bottom of this file)
# allows api calls and views on agora ciudadan to show up on agora election
# sets up httpauth file
# controls nginx settings
$enable_aelection = 'true'

# if activated, it will overwrite agora-election settings if present
$overwrite_aelection_settings = 'true'

# used to configure BABEL_DEFAULT_LOCALE in agora election
# (https://pythonhosted.org/Flask-Babel/)
$default_lang_code = 'es'

# FIXME sms provider data
$sms_provider = 'console'
$sms_domain_id = 'comercial'
$sms_login = ''
$sms_password = ''
$sms_sender_id = ''

# agora election postgresql database password
$db_aelection_password = '<PASSWORD>'

# agora election django secret key
$aelection_secret_key = '<PASSWORD>'


##### Nginx security (TODO)

# controls http auth in nginx
# FIXME this is currently coupled to enable_aelection
$enable_agora_httpauth = 'true'

# user/passsword for httpauth
$httpauth_user = 'prueba'
$httpauth_password = '<PASSWORD>'


##### Election orchestra

# Needed by the eopeers showmine command
$public_ipaddress = '127.0.0.1'




########## Go Puppet ##########

require agora
require sentry
require backup

if ($enable_aelection == 'true') {
require agora-election
}