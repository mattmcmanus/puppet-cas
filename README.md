# Puppet Module to install and configure CAS

*NO WHERE CLOSE TO FINISHED*

Easily setup production and development servers for CAS.

**Setting up a *production* environment**: 

* Installs and configures tomcat
* Creates a CAS user
* Automatically generates your CSR based off provided Org information and the server fqdn. 
* **Manual Steps:** Apply the SSL cert when your done and upload your war file to the right directory

**Setting up a *development* environment**: 

* Installs and configures tomcat and maven. (Including automatically setting up a self signed cert)
* Creates a CAS user
* The development class takes a url to a git repo of your maven overlay and sets up your workspace in the cas users home

## Requirements

This module depends on some other puppet modules. They are all listed below:

* [puppet-get](https://github.com/vurbia/puppet-git)

## Variables

Interested in what variables you can set? Read the source…Sorry. This is still under heavy development

## Example Code

### Production Server

    node 'cas.example.com' inherits basenode {  
      class{'cas::production':
        ou => "GIS", o => "University", l => "City", st => "PA"
      }
    }

### Development Server

    node 'dev-cas.example.com' inherits basenode {
      class {'cas::development': 
        maven_repo    => 'git@github.com:user/university-cas-server.git',
        project_name  => 'university-cas-server'
      }
    }