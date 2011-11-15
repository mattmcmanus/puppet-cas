class cas::development (
  $settings_dir   = $cas::params::tomcat_settings_dir,
  $webapps_dir    = $cas::params::tomcat_webapps_dir,
  $password       = $cas::params::tomcat_password,
  $keystore       = $cas::params::tomcat_keystore,
  $user           = $cas::params::user,
  $user_home      = $cas::params::user_home,
  $workspace      = $cas::params::user_workspace,
  $project_name, 
  $maven_repo
) inherits cas {
  # Install the required packages to use the maven overlay
  package { ['maven2', 'ant', 'maven-ant-helper']: 
      ensure => present
  }
  
  #        Generate self-signed keys for DEV
  # ==================================================
  Exec['create-tomcat-keystore'] -> Exec['export-key'] -> Exec['import-key'] ~> Service['tomcat6']
  exec {
    'create-tomcat-keystore':
      command => "keytool -genkey -dname \"cn=$fqdn, ou=Test, o=Test, l=Test, st=Test c=US\" -alias tomcat -keyalg RSA -keypass \"changeit\" -keystore $keystore -storepass \"changeit\" -validity 365",
      creates => $keystore,
      require => Package['tomcat6'];
    'export-key':
      command => "keytool -export -alias tomcat -keystore $keystore -storepass \"changeit\" -file $user_home/cas-server.crt",
      user => $user,
      cwd => $user_home,
      creates => "$user_home/cas-server.crt";
    'import-key':
      command => "keytool -import -file $user_home/cas-server.crt -storepass \"changeit\" -keystore /etc/java-6-sun/security/cacerts",
      unless => "keytool -list -keystore /etc/java-6-sun/security/cacerts -storepass $password -alias tomcat",
      user => $user,
      cwd => $user_home;
  }
  
  #        Setup Maven workspace
  # ==================================================
  file {
    # Create the maven workspace
    $workspace:
      ensure => directory,
      owner => $user,
      group => $user,
      require => User[$user];
  }

  # Checkout Maven Repo
  git::clone { $project_name:
    source => $maven_repo,
    localtree => $workspace,
    user => $user;
  }
}