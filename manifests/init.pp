class jboss (
  $version        = '7.1.1',
  $native_version = '2.0.10',
  $install_dir    = 'C:/jboss',
) {

  $maj_min_ver = regsubst($version, '^(\d+\.\d+)\..*', '\1')
  $jboss_dir   = "${install_dir}/jboss-as-${version}.Final"

  file { $install_dir:
    ensure => directory,
  }

  remote_file { "jboss-as.zip":
    ensure  => present,
    path    => "${jboss_dir}.zip",
    source  => "http://download.jboss.org/jbossas/${maj_min_ver}/jboss-as-${version}.Final/jboss-as-${version}.Final.zip",
    require => File[$install_dir],
  } ->
  unzip { 'jboss-as':
    source  => "${jboss_dir}.zip",
    creates => $jboss_dir,
  }

  remote_file { "jboss-native.zip":
    ensure  => present,
    path    => "${install_dir}/jboss-native-${native_version}-windows-x64-ssl.zip",
    source  => "http://downloads.jboss.org/jbossnative//${native_version}.GA/jboss-native-${native_version}-windows-x64-ssl.zip",
    require => File[$install_dir],
  } ->
  unzip { 'jboss-native':
    source      => "${install_dir}/jboss-native-${native_version}-windows-x64-ssl.zip",
    destination => $jboss_dir,
    creates     => "${jboss_dir}/bin/jbosssvc.exe",
    require     => Unzip['jboss-as'],
  }

  file { "${jboss_dir}/standalone/log":
    ensure  => directory,
    require => Unzip['jboss-as'],
  }
  file { "${jboss_dir}/standalone/log/standalone.log":
    ensure  => file,
    require => Unzip['jboss-as'],
    before  => Service['jboss'],
  }
  file { "${jboss_dir}/standalone/log/shutdown.log":
    ensure  => file,
    require => Unzip['jboss-as'],
    before  => Service['jboss'],
  }

  # Template uses:
  #   - $jboss_dir
  file { "${jboss_dir}/bin/service.bat":
    ensure  => file,
    content => template('jboss/service.bat.erb'),
    require => Unzip['jboss-native'],
    before  => Exec['install-jboss-service'],
  }
  file { "${jboss_dir}/bin/standalone.conf.bat":
    ensure  => file,
    content => template('jboss/standalone.conf.bat.erb'),
    require => Unzip['jboss-native'],
    before  => Exec['install-jboss-service'],
  }

  exec { "install-jboss-service":
    command  => "${jboss_dir}/bin/service.bat install",
    unless   => 'Get-Service "JBAS50SVC"',
    cwd      => "${jboss_dir}/bin",
    provider => powershell,
    require  => Unzip['jboss-native'],
  } ->
  service { 'jboss':
    name   => 'JBAS50SVC',
    ensure => stopped,
  }

}
