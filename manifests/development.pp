class cas::development inherits cas {
  
  include cas
  include cas::tomcat
  
  $tomcat_keystore = "/etc/tomcat6/.keystore"
  
  package { ['maven2', 'ant', 'maven-ant-helper']: 
      ensure => present
  }
  
  #        Generate self-signed keys for DEV
  # ==================================================
  exec {
    'create-tomcat-keystore':
      command => "keytool -genkey -dname \"cn=$fqdn, ou=Test, o=Test, l=Test, st=Test c=US\" -alias tomcat -keyalg RSA -keypass \"changeit\" -keystore $tomcat_keystore -storepass \"changeit\" -validity 365",
      creates => $tomcat_keystore,
      require => Package['tomcat6'];
    'export-key':
      command => "keytool -export -alias tomcat -keystore $tomcat_keystore -storepass \"changeit\" -file $cas_home/cas-server.crt",
      user => $cas_user,
      cwd => $cas_home,
      creates => "$cas_home/cas-server.crt",
      require => Exec['create-tomcat-keystore'];
    'import-key':
      command => "keytool -import -file $cas_home/cas-server.crt -keystore /etc/java-6-sun/security/cacerts",
      unless => "keytool -list -keystore /etc/java-6-sun/security/cacerts -storepass $tomcat_password -alias tomcat",
      user => $cas_user,
      cwd => $cas_home,
      require => Exec['export-key'],
      notify => Service['tomcat6'];
  }
  
  #        Setup Maven workspace
  # ==================================================
  $cas_workspace = "$cas_home/workspace"
  
  if !$cas_maven_repo {
    fail("You need to define the varible \$cas_maven_repo! How the hell am I supposed to clone nothing?")
  } 
  
  file {
    # Create the maven workspace
    $cas_workspace:
      ensure => directory,
      owner => $cas_user,
      group => $cas_user,
      require => User[$cas_user];
  }

  # Checkout Maven Repo
  git::clone { $cas_name:
    source => $cas_maven_repo,
    localtree => $cas_workspace,
    user => $cas_user;
  }
  
  exec { 
    "maven-clean-build":
      command => 'mvn clean package',
      user => $cas_user,
      cwd => $cas_workspace,
      #creates => "$cas_workspace/target",
      refreshonly => true,
      require => File[$cas_workspace]
  }
}