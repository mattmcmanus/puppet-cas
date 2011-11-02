class cas::development inherits cas {
  
  include cas
  include cas::tomcat
  
  $tomcat_keystore = "/etc/tomcat6/keystore"
  
  package { ['maven2', 'ant', 'maven-ant-helper']: 
      ensure => present
  }
  
  #        Generate self-signed keys for DEV
  # ==================================================
  exec {
    'create-tomcat-keystore':
      command => "keytool -genkey -dname \"cn=localhost, ou=test, o=CAS, l=test, st=test c=US\" -alias tomcat -keyalg RSA -keypass \"$tomcat_password\" -keystore $tomcat_keystore -storepass \"$tomcat_password\" -validity 365",
      creates => $tomcat_keystore,
      require => Package['tomcat6'];
    'export-key':
      command => "keytool -export -alias tomcat -keystore $tomcat_keystore -storepass $tomcat_password -file $cas_home/cas-server.crt",
      user => $cas_user,
      cwd => $cas_home,
      creates => "$cas_home/cas-server.crt",
      require => Exec['create-tomcat-keystore'];
    'import-key':
      command => "keytool -import -file server.crt -keystore $JAVA_HOME/jre/lib/security/cacerts",
      unless => "keytool -list -keystore $tomcat_keystore -storepass $tomcat_password -alias tomcat",
      user => $cas_user,
      cwd => $cas_home,
      require => Exec['export-key'],
      notify => Service['tomcat6'];
  }
  
  #        Setup Maven workspace
  # ==================================================
  $cas_workspace = "$cas_home/workspace"
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
    source => 'git@github.com:mattmcmanus/arcadia-cas-server.git',
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