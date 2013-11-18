class cubrid {

  package { "cubrid":
    ensure => present,
    require => Exec["cubrid_repository"],
  }

  package { "cubrid-demodb":
    ensure => present,
    require => Package["cubrid"],
  }

  exec { "/usr/bin/add-apt-repository ppa:cubrid/cubrid && /usr/bin/apt-get update":
    alias => "cubrid_repository",
    require => Package["python-software-properties"],
    creates => "/etc/apt/sources.list.d/puppet-stable-${lsbdistcodename}.list",
  }

  package { "python-software-properties":
    ensure => present,
  }

  file { "/etc/opt/cubrid/cubrid.conf":
    ensure => present, 
    owner => "cubrid",
    group => "cubrid",
    mode => "0644",
    source => "puppet:///modules/cubrid/cubrid.conf",
    require => Package["cubrid-demodb"],
  }

  exec { '/usr/bin/sudo su -s $SHELL cubrid -c "/opt/cubrid/bin/cubrid server start demodb"':
    require => Package['cubrid-demodb'],
  }

}