class cas {
  # Variables
  $cas_version = "3.4.10"
  $cas_organization = "arcadia"
  $cas_name = "arcadia-cas-server"
  $cas_org_version = "1.0-alpha"

  # Create a cas user account
  $cas_user = "cas"
  $cas_home = "/home/$cas_user"
  
  users::account{ $cas_user:
    ensure => present,
    fullname => $cas_name
  }
  
  # Ensure that the Ubuntu partner sources are available
  # note: assuming ubuntu 11.04 for now
  apt::sources_list {
    "partner":
      ensure  => present,
      content => "deb http://archive.canonical.com/ubuntu natty partner\ndeb-src http://archive.canonical.com/ubuntu natty partner";
  }
  
  # Install java for the servers
  # - Thanks to: http://www.mogilowski.net/lang/en-us/2011/07/27/install-sun-java-with-puppet-on-ubuntu/
  file { "/var/cache/debconf/sun-java6.preseed":
    source => "puppet:///modules/cas/sun-java6.preseed",
    ensure => present
  }
  
  package { ["sun-java6-jdk", "sun-java6-jre"]:
    ensure  => present,
    responsefile => "/var/cache/debconf/sun-java6.preseed",
    require => [ Apt::Sources_list["partner"], File["/var/cache/debconf/sun-java6.preseed"] ],
    notify => Exec["update-alternatives"]
  }
  
  exec {"update-alternatives":
    command => "update-java-alternatives -s java-6-sun",
    require => Package["sun-java6-jdk"],
    refreshonly => true
  }
  
  $JAVA_HOME = "/usr/lib/jvm/java-6-sun"
  
  include cas::tomcat
}