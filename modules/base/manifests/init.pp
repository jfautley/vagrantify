class base {
    # Configure our Vagrant user
    user { "vagrant":
        ensure      => present,
        groups      => [ 'vagrant', 'wheel' ],
        managehome  => true,
        password    => sha1('vagrant'),
        shell       => '/bin/bash',
        require     => Group['vagrant'],
    }

    group { "vagrant":
        ensure      => present,
    }

    # Disable 'Requiretty' in /etc/sudoers
    augeas { "sudoers_norequiretty":
        context     => "/files/etc/sudoers",
        changes     => "set Defaults[*]/requiretty/negate ''",
    }
}
