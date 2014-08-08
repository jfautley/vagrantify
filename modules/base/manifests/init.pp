class base {
    # Configure our Vagrant user
    user { 'vagrant':
      ensure     => present,
      groups     => [ 'wheel' ],
      gid        => 'vagrant',
      managehome => true,
      password   => sha1('vagrant'),
      shell      => '/bin/bash',
      require    => Group['vagrant'],
    }

    group { 'vagrant':
      ensure      => present,
    }

    # Add the vagrant 'insecure key'
    ssh_authorized_key { 'vagrant insecure public key':
      ensure => present,
      user   => 'vagrant',
      type   => 'ssh-rsa',
      key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==',
    }

    # Ensure we can sudo
    file { '/etc/sudoers.d/00wheel-root':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
      content => "# Permit wheel group to do anything\n%wheel ALL=NOPASSWD: ALL\n",
    }

    # Disable 'Requiretty' in /etc/sudoers
    augeas { 'sudoers_norequiretty':
        context     => '/files/etc/sudoers',
        changes     => 'set Defaults[*]/requiretty/negate ""',
    }
}
