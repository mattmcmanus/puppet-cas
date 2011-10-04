define cas::deploy($path) {

  notice("Establishing http://$hostname:${cas::tomcat::tomcat_port}/$name/")

  file { "/var/lib/tomcat6/webapps/${name}.war":
    owner => 'root',
    source => $path,
  }

}