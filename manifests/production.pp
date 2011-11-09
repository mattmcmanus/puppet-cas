class cas::production (
  $password       = $cas::params::tomcat_password,
  $keystore       = $cas::params::tomcat_keystore,
  $user           = $cas::params::user,
  $user_home      = $cas::params::user_home,
  $ou,
  $o,
  $l,
  $st
) inherits cas {
  # Create the tomcat keystore and generate the CSR
  # NOTE: you will need to import the cert on your own 
  Exec['create-tomcat-keystore'] -> Exec['generate-csr']
  exec {
    'create-tomcat-keystore':
      command => "keytool -genkey -dname \"cn=$fqdn, ou=$ou, o=$o, l=$l, st=$st c=US\" -alias tomcat -keyalg RSA -keypass \"$password\" -keystore /etc/tomcat6/.keystore -storepass \"$password\" -validity 365 -keysize 2048",
      creates => $keystore,
      require => Package['tomcat6'];
    'generate-csr':
      command => "keytool -certreq -keyalg RSA -file $user_home/$fqdn.csr -keystore $keystore  -alias tomcat",
      user => $user,
      cwd => $user_home,
      creates => "$user_home/$fqdn.crt",
  }
}