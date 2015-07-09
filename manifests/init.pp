class jboss (
  $version = '7.1.1',
) {

  remote_file { "C:/jboss-as-${version}.Final.zip":
    ensure => present,
    source => "http://download.jboss.org/jbossas/7.1/jboss-as-${version}.Final/jboss-as-${version}.Final.zip",
    before => Unzip['jboss_installer'],
  }

  unzip { "jboss_installer":
    source  => "C:/jboss-as-${version}.Final.zip",
    creates => "C:/jboss-as-${version}.Final",
  }

}
