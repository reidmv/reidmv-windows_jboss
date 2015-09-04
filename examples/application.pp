class windows_client {
  include jboss

  jboss::ear { 'demo327':
    ensure => present,
    source => 'https://example.com/versions/327/demo327.ear',
  }

  jboss::ear { 'invoker':
    ensure => present,
    source => 'https://example.com/versions/invoker/invoker.ear',
  }

  jboss::ear { 'jmx-console':
    ensure => present,
    source => 'https://example.com/versions/jmx/jmx.ear',
  }

}
