
class { '::mysql::server':
  root_password           => 'strongpassword',
  remove_default_accounts => true,
  override_options        => $override_options
}

user { "wordpress":
  ensure      => present,
  comment     => "wordpress",
  managehome  => true,
  home        => "/home/wordpress",
}

package { "php":
  ensure  => present,
  notify  => Service['httpd'],
}

package { "php-mysql":
  ensure  => present,
  notify  => Service['httpd'],
}

class { 'wordpress':
  wp_owner    => 'wordpress',
  install_dir => '/var/www/html',
  wp_group    => 'wordpress',
  db_user     => 'wordpress',
  db_password => 'hvyH(S%t(\"0\"16',
  notify      => Service['httpd'],
}

service { "httpd" :
  ensure    => running,
  enable    => true,
}


Class['::mysql::server']
-> User['wordpress']
-> Package['php']
-> Package['php-mysql']
-> Class['wordpress']
-> Service['httpd']

