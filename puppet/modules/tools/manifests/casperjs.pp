class tools::casperjs {

    package { ["libfreetype6", "fontconfig"]:
        ensure => latest,
    }

    # PhantomJS
    exec { "clone phantomjs repo":
        creates => "/usr/local/src/phantomjs",
        cwd     => "/usr/local/src/",
        command => "git clone git://github.com/ariya/phantomjs.git",
    }

    -> exec { "phantom dependencies":
        command => "apt-get install -y build-essential g++ flex bison gperf ruby perl libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev libpng-dev libjpeg-dev"
    }

    -> exec { "add remote":
        cwd     => "/usr/local/src/phantomjs",
        command => "git remote add vital https://github.com/Vitallium/phantomjs.git && git fetch vital && git checkout -b fix-WOFF-file-support vital/fix-WOFF-file-support",
    }

    -> exec { "compile remote":
        cwd     => "/usr/local/src/phantomjs",
        command => "./build.sh",
    }

    -> exec { "install phantomjs":
        creates => "/usr/local/bin/phantomjs",
        cwd     => "/usr/local/src/phantomjs",
        command => "cp bin/phantomjs /usr/local/bin/ && chmod +x /usr/local/bin/phantomjs",
        require => [ Package["libfreetype6"], Package["fontconfig"] ],
    }

    exec { "clone casperjs":
        creates => "/usr/local/src/casperjs",
        cwd     => "/usr/local/src",
        command => "git clone git://github.com/n1k0/casperjs.git casperjs",
        require => [ Exec['install phantomjs'], Class['git'] ],
    }

    -> exec { "install casperjs":
        creates => "/usr/local/bin/casperjs",
        cwd     => "/usr/local/bin",
        command => "ln -s /usr/local/src/casperjs/bin/casperjs",
    }

}
