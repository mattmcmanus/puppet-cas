class cas (
  $environment    = 'development',
  $user           = $cas::params::user,
  $user_home      = $cas::params::user_home,
  $password       = $cas::params::tomcat_password,
  $keystore       = $cas::params::tomcat_keystore,
  $user           = $cas::params::user,
  $user_home      = $cas::params::user_home,
  $ou             = $cas::params::ou,
  $o              = $cas::params::o,
  $l              = $cas::params::l,
  $st             = $cas::params::st,
  $workspace      = $cas::params::user_workspace,
  $maven_repo     = undef
) inherits cas::params {
  
  # Custom user class. May need to change.
  users::account{ $user:
    ensure => present,
    fullname => $user_home
  }
  
  
  # ----------------------------------------------------
  #          Install and configure Java
  # ----------------------------------------------------
  
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
  # ----------------------------------------------------
  #          Install and configure Maven
  # ----------------------------------------------------
  # Install the required packages to use the maven overlay
  if $maven_repo != undef {
    package { ['maven2', 'ant', 'maven-ant-helper']: ensure => present }
    file {
      # Create the maven workspace
      $workspace:
        ensure => directory,
        owner => $user,
        group => $user,
        require => User[$user];
    }
  
    # Checkout Maven Repo
    git::clone { $maven_repo:
      source => $maven_repo,
      localtree => $workspace,
      user => $user,
      require => File[$workspace];
    }
  }
  
  # ----------------------------------------------------
  #          Install and configure Tomcat
  # ----------------------------------------------------
  class{'cas::tomcat': user => $user, user_home => $user_home}
  
  # ----------------------------------------------------
  #          Create and configure Security Keystores
  # ----------------------------------------------------
  exec {
    'create-tomcat-keystore':
      command => "keytool -genkey -dname \"cn=$fqdn, ou=$ou, o=$o, l=$l, st=$st c=US\" -alias tomcat -keyalg RSA -keypass \"$password\" -keystore /etc/tomcat6/.keystore -storepass \"$password\" -validity 365 -keysize 2048",
      creates => $keystore,
      require => Package['tomcat6'];
  }
  
  if ($environment == 'production') {
    # Create the tomcat keystore and generate the CSR
    # NOTE: you will need to import the cert on your own 
    Exec['create-tomcat-keystore'] -> Exec['generate-csr']
    exec {
      'generate-csr':
        command => "keytool -certreq -keyalg RSA -file $user_home/$fqdn.csr -keystore $keystore  -alias tomcat",
        user => $user,
        cwd => $user_home,
        creates => "$user_home/$fqdn.crt",
    }
  } else {
    Exec['create-tomcat-keystore'] -> Exec['export-key'] -> Exec['import-key'] ~> Service['tomcat6']
    exec {
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
  }
}