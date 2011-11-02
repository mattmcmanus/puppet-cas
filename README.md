# Puppet Module to install and configure CAS

*NO WHERE CLOSE TO FINISHED*

## Requirements

This module depends on some other puppet modules. They are all listed below:

* [puppet-get](https://github.com/vurbia/puppet-git)

## Variables

* **$tomcat_password**: Password for tomcat admin user and keystore
* **$tomcast_settings_dir**: Defaults to "/etc/tomcat6"
* **$tomcat_keystore**: Defaults to "$tomcast_settings_dir/keystore"
* **$tomcat_keystore_password**
* **$cas_maven_repo**: Git repo where maven files are kept

## Example Code

### Production Server

    node 'cas.server.com' inherits basenode {    
      include cas
    }

### Development Server

    node 'dev-server.com' inherits 'cas.server.com' {
      $cas_maven_repo = 'git@github.com:user/repo.git'
      
      include cas::development
    }