node default {

  host { 'puppet.evry.dev':
    ensure       => 'present',
    host_aliases => ['puppet'],
    ip           => '172.20.20.20',
    target       => '/etc/hosts',
  }

  Package { ensure => "latest" }
  $tools = [ "screen", "strace", "bind-utils" ]
  package { $tools: }
}  

node 'client1.evry.dev', 'client2.evry.dev' inherits default {

  service { 'puppet':
    ensure => running,
    enable => true,
  }
}

node 'puppet.evry.dev' inherits default {

  package { 'puppet-server':
    ensure => latest,
    require => Host['puppet.evry.dev'],
  }
  
  service { 'puppetmaster':
    ensure => running,
    enable => true,
    require => Package['puppet-server'],
  }

#  # http://docs.puppetlabs.com/puppetdb/1.3/install_from_source.html#step-3-option-a-run-the-ssl-configuration-script
#  # Fixes things in /etc/puppetdb/ssl/
#  exec {'fix-keystore':
#    command => '/usr/sbin/puppetdb-ssl-setup -f',
#    #onlyif => '/usr/bin/test -f /var/lib/puppet/ssl/certs/ca.pem',
#    #notify => Service[$puppetdb_service],
#    #require => Service['puppetmaster'],
#    notify => Service['puppetdb'],
#  }
#
  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    listen_address => '0.0.0.0',
    #require => Package['puppet-server'],
    require => Service['puppetmaster'],
    puppetdb_version => latest,
  }
  # Configure the puppet master to use puppetdb
  class { 'puppetdb::master::config': }
    
  class {'dashboard':
    dashboard_site => $fqdn,
    dashboard_port => '3000',
    require => Package["puppet-server"],
  }

  ##we copy rather than symlinking as puppet will manage this
  file {'/etc/puppet/puppet.conf':
    ensure => present,
    owner => root,
    group => root,
    source => "/vagrant/puppet/puppet.conf",
    #notify => [Service['puppetmaster'],Service['puppet-dashboard'],Service['puppet-dashboard-workers']],
    notify => Service['puppetmaster'],
    require => Package['puppet-server'],
  }
    
  file {'/etc/puppet/autosign.conf':
    ensure => link,
    owner => root,
    group => root,
    source => "/vagrant/puppet/autosign.conf",
    #notify => [Service['puppetmaster'],Service['puppet-dashboard'],Service['puppet-dashboard-workers']],
    notify => Service['puppetmaster'],
    require => Package['puppet-server'],
  }
  
  file {'/etc/puppet/auth.conf':
    ensure => link,
    owner => root,
    group => root,
    source => "/vagrant/puppet/auth.conf",
    #notify => [Service['puppetmaster'],Service['puppet-dashboard'],Service['puppet-dashboard-workers']],
    notify => Service['puppetmaster'],
    require => Package['puppet-server'],
  }
  
  file {'/etc/puppet/fileserver.conf':
    ensure => link,
    owner => root,
    group => root,
    source => "/vagrant/puppet/fileserver.conf",
    #notify => [Service['puppetmaster'],Service['puppet-dashboard'],Service['puppet-dashboard-workers']],
    notify => Service['puppetmaster'],
    require => Package['puppet-server'],
  }
  
  file {'/etc/puppet/modules':
    mode => '0644',
    recurse => true,
  }
  
  file { '/etc/puppet/hiera.yaml':
    ensure => link,
    owner => root,
    group => root,
    source => "/vagrant/puppet/hiera.yaml",
    #notify => [Service['puppetmaster'],Service['puppet-dashboard'],Service['puppet-dashboard-workers']],
    notify => Service['puppetmaster'],
  }
  
  file { '/etc/puppet/hieradata':
    mode => '0644',
    recurse => true,
  }
}
