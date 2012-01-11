class cas::params {
  # CAS user
  $user = "cas"
  $user_home = "/home/$user"
  $user_workspace = "$user_home/workspace"
  
  # ----------------------------------------------------
  #          Tomcat Settings
  # ----------------------------------------------------
  $tomcat_password = "changeit"
  
  $tomcat_settings_dir = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => "/etc/tomcat6",
    default => $tomcat_settings_dir
  }
  
  $tomcat_keystore = "$tomcat_settings_dir/.keystore"
  
  $tomcat_webapps_dir = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => "/var/lib/tomcat6/webapps",
    default => $tomcat_webapps_dir
  }
  
  # ----------------------------------------------------
  #          Keystore Settings
  # ----------------------------------------------------
  $ou = "TEST"
  $o = "TEST"
  $l = "TEST"
  $st = "TEST"
}