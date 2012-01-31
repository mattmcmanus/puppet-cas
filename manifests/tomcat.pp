# Based on work done here: https://github.com/mpdehaan/puppet-tomcat-demo/blob/master/modules/tomcat/manifests/init.pp
class cas::tomcat (
  $settings_dir  = $cas::params::tomcat_settings_dir,
  $webapps_dir   = $cas::params::tomcat_webapps_dir,
  $password      = $cas::params::tomcat_password,
  $keystore      = $cas::params::tomcat_keystore,
  $user,
  $user_home
) inherits cas::params {
  
  #            Packages, Services & Files
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = 
  package { 
    ['tomcat6', 'tomcat6-admin', 'tomcat6-user']:
      ensure => installed;
    'apache2':
      ensure => purged;
  }
  
  file { 
    "$settings_dir/tomcat-users.xml":
      owner => 'root',
      require => Package['tomcat6'],
      notify => Service['tomcat6'],
      content => template('cas/tomcat/tomcat-users.xml.erb');
    "$settings_dir/server.xml":
      owner => 'root',
      require => Package['tomcat6'],
      notify => Service['tomcat6'],
      content => template('cas/tomcat/server.xml.erb');
    # Simplify deployements by linking to the tomcat dir in CAS home
    "$user_home/webapps":
      ensure => link,
      target => $webapps_dir,
      require => User[$user];
    "/var/log/cas":
      ensure => directory,
      owner => 'tomcat6',
      group => 'tomcat6';
  }
  
  augeas { 
    "default/tomcat6/AUTHBIND":
      context => "/files/etc/default/tomcat6",
      changes => "set AUTHBIND yes",
      notify  => Service["tomcat6"];
    "default/tomcat6/JAVA_HOME":
      context => "/files/etc/default/tomcat6",
      changes => "set JAVA_HOME /usr/lib/jvm/java-6-sun",
      notify  => Service["tomcat6"];
  }
  
  service { 
    'tomcat6':
      ensure => running,
      require => Package['tomcat6'];
    'apache2':
      ensure => stopped
  }
  
}

