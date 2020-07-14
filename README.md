# MP3 Player using Yocto

This project is a Yocto layer implementation for an mp3 player

## Tutorial

### Getting started

- Create a Folder named (let's name it YOCTO)

then, in that folder start to get the elementary layers

>git clone git://git.yoctoproject.org/poky -b zeus \ 

>git clone https://github.com/openembedded/meta-openembedded -b zeus \ 

>git clone https://github.com/agherzan/meta-raspberrypi -b zeus 

- Source command: *do this command while you are in the main folder (YOCTO)

> source pokey/oe-init-build-env [output directory name let's name it rpi-build]

- now you need to add this layers to your YOCTO/rpi-build/bblayers.conf file, it will look like:

**NOTE:** remember to check the extra layers dependencies \
(like meta-raspberrypi dependencies, you will find them in its README: "meta-oe, meta-multimedia, meta-networking, meta-python")

>BBLAYERS ?= " \ \
>  /home/$USER/Yocto/poky/meta \ \
>  /home/$USER/Yocto/poky/meta-poky \ \
>  /home/$USER/Yocto/poky/meta-yocto-bsp \ \
>  /home/$USER/Yocto/meta-openembedded/meta-oe \ \
>  /home/$USER/Yocto/meta-openembedded/meta-multimedia \ \
>  /home/$USER/Yocto/meta-openembedded/meta-networking \ \
>  /home/$USER/Yocto/meta-openembedded/meta-python \ \
>  /home/$USER/Yocto/meta-raspberrypi \ \
>  /home/$USER/Yocto/meta-mp3_player \ \
>  "

and you need to change the machine variable at YOCTO/rpi-build/local.conf file to MACHINE ?= "raspberrypi3"

to build use this:
> bitbake -k core-image-base

to burn the image to SDcard
>dd bs=4M if=core-image-base-raspberrypi3.rpi-sdimg of=/dev/sdX status=progress conv=fsync

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

https://docs.google.com/document/d/1TmUVk_P2_C1ha5NE5x72geAaHcmcuYk9X0hENDnPoNM/edit

## References

- https://www.yoctoproject.org/docs/3.0.2/mega-manual/mega-manual.html

**Networking**

- https://hub.mender.io/t/how-to-configure-networking-using-systemd-in-yocto-project/1097

**paths variables**

- https://git.yoctoproject.org/cgit.cgi/poky/plain/meta/conf/bitbake.conf

**other commands**
- https://gist.github.com/gemad/b870ae57e7a2391b0e9b5a0146e2ac29

