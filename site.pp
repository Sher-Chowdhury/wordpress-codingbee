
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




class { 'wordpress':
  wp_owner    => 'wordpress',
  wp_group    => 'wordpress',
  db_user     => 'wordpress',
  db_password => 'hvyH(S%t(\"0\"16',
}


Class['::mysql::server']
-> User['wordpress']
-> Class['wordpress']

