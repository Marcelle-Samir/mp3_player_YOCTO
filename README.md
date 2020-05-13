# MP3 Player using Yocto

This project is a Yocto layer implementation for an mp3 player

## Tutorial

### Networking

For now, only WiFi is enabled with static IP. 
First, we changed the init manager to systemd. This can be done by adding these lines to local.conf in your build directory:

> DISTRO_FEATURES_append = " systemd "\
> DISTRO_FEATURES_BACKFILL_CONSIDERED = "sysvinit"\
> VIRTUAL-RUNTIME_init_manager = "systemd"\
> VIRTUAL-RUNTIME_initscripts = ""


Also, we need to add WiFi supporting packages:

> DISTRO_FEATURES_append = " wifi "\
> IMAGE_INSTALL_append = " linux-firmware-rpidistro-bcm43430 "

Finally, we need to enable ssh to be able to log into the terminal, and UART for WiFi interface to work.

> EXTRA_IMAGE_FEATURES_append = " ssh-server-openssh allow-empty-password"\
> ENABLE_UART = "1"

The layer contains 2 recipes:

recipe-core, which sets proper configurations (Static IP) in systemd-conf.\
recipe-connectivity, which determines configuration for wpa_supplicant (Network and Password).

You can check the references for further help on how they are created.

## References

**Networking**

- https://hub.mender.io/t/how-to-configure-networking-using-systemd-in-yocto-project/1097
