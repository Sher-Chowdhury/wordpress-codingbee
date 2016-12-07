


class { '::mysql::server':
  package_name            => 'mariadb-server',
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


class { '::php':
  ensure       => latest,
  manage_repos => true,
  },
  settings   => {
    'PHP/max_execution_time'  => '300',
    'PHP/max_input_time'      => '300',
    'PHP/memory_limit'        => '256M',
    'PHP/post_max_size'       => '32M',
    'PHP/upload_max_filesize' => '32M',
    'Date/date.timezone'      => 'Europe/London',
  },
}



package { "php-gd":
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
-> Class['php']
-> Package['php-mysql']
-> Service['httpd']

