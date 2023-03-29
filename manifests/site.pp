node master.puppet {
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
  include nginx
  nginx::resource::server { '80 port on master.puppet':
    listen_port => 80,
    proxy => 'http://192.168.210.152',
  }
  nginx::resource::server { '81 port on master.puppet':
    listen_port => 81,
    proxy => 'http://192.168.210.153',
  }
  exec { 'config SELinux Booleans':
    command => 'setsebool -P httpd_can_network_connect on',
    path    => "/usr/sbin",
  }
}

node slave1.puppet {
  package { 'httpd':
    ensure => installed,
  }
  file { '/var/www/html/index.html':
    ensure => present,
    source => "/vagrant/index.html",
  }
  service { 'httpd':
    ensure => running,
    enable => true,
  }
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
}

node slave2.puppet {
  package { 'httpd':
    ensure => installed,
  }
  package { 'php':
    ensure => installed,
  }
  file { '/var/www/html/index.php':
    ensure => present,
    source => "/vagrant/index.php",
  }
  service { 'php-fpm':
    ensure => running,
    enable => true,
  }
  service { 'httpd':
    ensure => running,
    enable => true,
  }
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
}

node mineserver.puppet {
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
include minecraft
}
