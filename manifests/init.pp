class jboss (
  $version = '7.1.1',
  $native_version = '2.0.10',
) {

  remote_file { "C:/jboss-as-${version}.Final.zip":
    ensure => present,
    source => "http://download.jboss.org/jbossas/7.1/jboss-as-${version}.Final/jboss-as-${version}.Final.zip",
  } ->

  unzip { "jboss_installer":
    source  => "C:/jboss-as-${version}.Final.zip",
    creates => "C:/jboss-as-${version}.Final",
  }

  remote_file { "C:/jboss-native-${native_version}-windows-x64-ssl.zip":
    ensure => present,
    source => "http://downloads.jboss.org/jbossnative//${native_version}.GA/jboss-native-${native_version}-windows-x64-ssl.zip",
  }

}
