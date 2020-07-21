FILESEXTRAPATHS_prepend := "${THISDIR}:"
SUMMARY = "Initial boot script"
DESCRIPTION = "Script to do any first boot init, started as a systemd service which removes itself once finished"
LICENSE = "CLOSED"
PR = "r3"

SRC_URI +=  " \
    file://initscript.sh \
    file://initscript.service \
"

do_install () {
    install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/initscript.sh ${D}/${sbindir}

    install -d ${D}${sysconfdir}/systemd/system/
    install -m 0777 ${WORKDIR}/initscript.service ${D}${sysconfdir}/systemd/system

    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    ln -s ${D}${sysconfdir}/systemd/system/initscript.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/initscript.service
}

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "initscript.service"

inherit allarch systemd

