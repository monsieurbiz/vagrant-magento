class ps_ioncubeloader (

	$module_status		= $ps_ioncubeloader::params::module_status,
	$apache_modules_dir	= $ps_ioncubeloader::params::apache_modules_dir,
	$apache_php_dir		= $ps_ioncubeloader::params::apache_php_dir,
	$php_version		= $ps_ioncubeloader::params::php_version,
	$php_priority		= $ps_ioncubeloader::params::php_priority,

) inherits ps_ioncubeloader::params {

        file { "/etc/apache2/modules":
            ensure => directory,
            owner => 'root'
        }
	-> file { "${apache_modules_dir}":
		ensure => 'directory',
		mode => 750,
		owner => 'root',
	}
	
	file { "${apache_modules_dir}ioncube_loader_lin_${php_version}.so":
		ensure => $module_status,
	    source => "puppet:///modules/ps_ioncubeloader/ioncube_loader_lin_${php_version}.so",
	    subscribe => File["${apache_modules_dir}"]
	}
	
	file { "${apache_php_dir}conf.d/${php_priority}-ps_ioncubeloader.ini":
		ensure => $module_status,
	    content => template("ps_ioncubeloader/ps_ioncubeloader.ini.erb"),
	    subscribe => File["${apache_modules_dir}ioncube_loader_lin_${php_version}.so"]
	}
	
	exec { "apache_restart-icl":
    	command => "/etc/init.d/apache2 reload",
		refreshonly => true,
    	subscribe => File["${apache_php_dir}conf.d/${php_priority}-ps_ioncubeloader.ini"],
	}

}