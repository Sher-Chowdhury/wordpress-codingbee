
class { '::mysql::server':
  root_password           => 'strongpassword',
  remove_default_accounts => true,
}


mysql::db { 'wordpress_db':
  host     => 'localhost',
  user     => 'wordpress',
  password => 'password123',
  grant    => 'ALL',
}

user { "wordpress":
  ensure      => present,
  comment     => "wordpress",
  managehome  => true,
  home        => "/home/wordpress",
}

package { "mysql":
  ensure  => present,
  notify  => Service['httpd'],
}

package { "php":
  ensure  => present,
  notify  => Service['httpd'],
}

package { "php-mysql":
  ensure  => present,
  notify  => Service['httpd'],
}

#class { 'wordpress':
#  wp_owner    => 'wordpress',
#  install_dir => '/var/www/html',
#  version     => '4.6.1',
#  wp_group    => 'wordpress',
#  db_user     => 'wordpress',
#  db_password => 'password123',
#  notify      => Service['httpd'],
#}

service { "httpd" :
  ensure    => running,
  enable    => true,
}


Class['::mysql::server']
-> User['wordpress']
-> Package['mysql']
-> Package['php']
-> Package['php-mysql']
-> Service['httpd']

