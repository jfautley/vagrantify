class network {
    # Remove unique identifiers from our eth0 config
    augeas { "network-fixeth0":
        context     => "/files/etc/sysconfig/network-scripts/ifcfg-eth0",
        changes     => [
                        # Remove HWADDR
                        "rm HWADDR",
                        # Remove UUID
                        "rm UUID",
                        # No, NetworkManager, no.
                        "rm NM_CONTROLLED",
                        # Bah, noise.
                        "rm TYPE",
                        ],
    }

    # Make sure udev doesn't try and rename things
    file { "/etc/udev/rules.d/70-persistent-net.rules":
            ensure  => absent,
    }
}
