
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
}

package { "php-mysql":
  ensure  => present,
}

class { 'wordpress':
  wp_owner    => 'wordpress',
  install_dir => '/var/www/html',
  wp_group    => 'wordpress',
  db_user     => 'wordpress',
  db_password => 'hvyH(S%t(\"0\"16',
}


Class['::mysql::server']
-> User['wordpress']
-> Package['php']
-> Package['php-mysql']
-> Class['wordpress']

