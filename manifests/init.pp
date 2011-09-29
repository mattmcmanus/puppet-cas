class cas {
  
  # Ensure that the Ubuntu partner sources are available
  # note: assuming ubuntu 11.04 for now
  apt::sources_list {
    "partner":
      ensure  => present,
      content => "deb http://archive.ubuntu.com/ubuntu/ natty partner";
    "partner-src":
      ensure => present,
      content => "deb-src http://archive.ubuntu.com/ubuntu/ natty partner"
  }
  
  package {
    ['sun-java6-jdk', 'tomcat', 'maven2', 'ant', 'maven-ant-helper']: ensure => present
  }
  
}