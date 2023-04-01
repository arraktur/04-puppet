class minecraft {
  package {  'java':
    name   => java-17-openjdk,
    ensure => present,
  }
  file { '/opt/minecraft':
    ensure => directory,
  }
  wget::retrieve { 'download minecraft server':
    source      => 'https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar',
    destination => '/opt/minecraft/',
    timeout     => 0,
    verbose     => false,
    require => File['/opt/minecraft'],  
  }
  exec { 'init start server':
    cwd     => '/opt/minecraft',
    command => 'java -Xmx1024M -Xms1024M -jar server.jar --nogui',
    path    => "/usr/bin",
    unless  => 'test -e /opt/minecraft_2/eula.txt',
  }
  file { '/opt/minecraft/eula.txt':
    content => "eula=true",
    require => Exec['init start server'],
  }  
  vcsrepo { '/opt/minecraft/mcrcon':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/Tiiffi/mcrcon.git',
    require => File['/opt/minecraft'],
  }
  exec { 'make mcrcon':
    cwd     => '/opt/minecraft/mcrcon',
    command => 'make',
    path    => "/usr/bin",
    unless  => 'test -x /opt/minecraft/mcrcon/mcrcon',
  }
  exec { 'install mcrcon':
    cwd     => '/opt/minecraft/mcrcon',
    path    => "/usr/bin",
    command => 'make install',
    unless  => 'test -x /usr/local/bin/mcrcon',   
  }
  file { '/opt/minecraft/server.properties':
    ensure => file,
    source => 'puppet:///modules/minecraft/server.properties',
  }
  file { '/etc/systemd/system/minecraft.service':
    ensure => file,
    source => 'puppet:///modules/minecraft/minecraft.service',
    require => File['/opt/minecraft/server.properties'],    
  }
  service { 'minecraft.service':
    ensure => running,
    enable => true,
    require => File['/etc/systemd/system/minecraft.service'],
  }
}
