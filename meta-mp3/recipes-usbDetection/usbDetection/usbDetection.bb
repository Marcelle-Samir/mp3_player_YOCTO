FILESEXTRAPATHS_prepend := "${THISDIR}:"
SUMMARY = "Initial boot script"
DESCRIPTION = "Script to do any first boot init, started as a systemd service which removes itself once finished"
LICENSE = "CLOSED"
PR = "r3"

SRC_URI +=  " \
    file://usbDetection.sh \
    file://usbDetection.service \
"

do_install () {
    install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/usbDetection.sh ${D}/${sbindir}

    install -d ${D}${sysconfdir}/systemd/system/
    install -m 0777 ${WORKDIR}/usbDetection.service ${D}${sysconfdir}/systemd/system

    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    ln -s ${D}${sysconfdir}/systemd/system/usbDetection.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/usbDetection.service
}

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "usbDetection.service"

inherit allarch systemd

