# Based on work done here: https://github.com/mpdehaan/puppet-tomcat-demo/blob/master/modules/tomcat/manifests/init.pp

class cas::tomcat {
  
  
  #                        Variables
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = 
  if !$tomcat_password {
    fail("You need to define the varible \$tomcat_password!")
  } 
  
  $tomcat_settings_dir = $tomcat_settings_dir ? {
    "" => "/etc/tomcat6",
    default => $tomcat_settings_dir
  }
  
  $tomcat_keystore = $tomcat_keystore ? {
    "" => "$tomcat_settings_dir/keystore",
    default => $tomcat_keystore
  }
  
  if !$tomcat_keystore {
    fail("You need to define the varible \$tomcat_password!")
  } 
  
  #            Packages, Services & Files
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = 
  package { 
    ['tomcat6', 'tomcat6-admin', 'tomcat6-user']:
      ensure => installed;
    'apache2':
      ensure => absent;
  }

  file { 
    "$tomcat_settings_dir/tomcat-users.xml":
      owner => 'root',
      require => Package['tomcat6'],
      notify => Service['tomcat6'],
      content => template('cas/tomcat/tomcat-users.xml.erb');
    "$tomcat_settings_dir/server.xml":
      owner => 'root',
      require => Package['tomcat6'],
      notify => Service['tomcat6'],
      content => template('cas/tomcat/server.xml.erb'),
  }
  
  service { 'tomcat6':
    ensure => running,
    require => Package['tomcat6'],
  } 
  
  
}

