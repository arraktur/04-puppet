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
  file { '/opt/minecraft/eula.txt':
    content => "eula=true",
    require => Exec['init start server'],
  }  
  file { '/etc/systemd/system/minecraft.service':
    ensure => file,
    source => 'puppet:///modules/minecraft/minecraft.service',
  }
  service { 'minecraft.service':
    ensure => running,
    enable => true,
    require => File['/etc/systemd/system/minecraft.service'],
  }
}
