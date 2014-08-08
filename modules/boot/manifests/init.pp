class boot {
    # System bootloader config
    remove_kernel_arg {'rhgb': }
    remove_kernel_arg {'quiet': }

    # Remove the splashimage
    augeas { 'remove_grub_splash':
        context => '/files/etc/grub.conf',
        changes => [ 'rm splashimage', 'rm hiddenmenu' ],
    }
}

# Helpers
# Sets a kernel argument in the GRUB bootloader using the grubby tool
define boot_kernel_arg($value = '') {
    $argsval = $value ? {
        undef   => $name,
        ''      => $name,
        default => "${name}=${value}",
    }

    exec { "grubby-arg-${name}":
        command => "/sbin/grubby --update-kernel ALL --args '${argsval}'",
        unless  => "/sbin/grubby --info ALL | grep args= | grep '${argsval}'",
    }
}

# Removes an argument completely from the kernel boot args
define remove_kernel_arg() {
    exec { "grubby-arg-${name}":
        command => "/sbin/grubby --update-kernel ALL --remove-args '${name}'",
        onlyif  => "/sbin/grubby --info ALL | grep args= | grep ' ${name}'",
    }
}
