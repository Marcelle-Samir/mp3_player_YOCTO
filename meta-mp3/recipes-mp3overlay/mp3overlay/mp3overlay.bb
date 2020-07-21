LICENSE = "MIT"

FILESEXTRAPATHS_prepend := "${THISDIR}:"

SRC_URI += "file://audio_player.sh \
file://abtal_el_digital.mp3 \
file://Some_Things_Never_Change.mp3 \
file://Toy_Story.mp3 \
file://Try_Everything.mp3 \
file://you_will_be_in_my_heart.mp3"

deltask do_populate_lic
deltask do_package_qa

do_install () {
   install -d ${D}/mp3overlay/
   install -d ${D}/mp3overlay/Songs_list_source/
   install -m 0777 ${WORKDIR}/audio_player.sh ${D}/mp3overlay/
   install -m 0777 ${WORKDIR}/abtal_el_digital.mp3 ${D}/mp3overlay/Songs_list_source/
   install -m 0777 ${WORKDIR}/Some_Things_Never_Change.mp3 ${D}/mp3overlay/Songs_list_source/
   install -m 0777 ${WORKDIR}/Toy_Story.mp3 ${D}/mp3overlay/Songs_list_source/
   install -m 0777 ${WORKDIR}/Try_Everything.mp3 ${D}/mp3overlay/Songs_list_source/
   install -m 0777 ${WORKDIR}/you_will_be_in_my_heart.mp3 ${D}/mp3overlay/Songs_list_source/
}

FILES_${PN} = "/mp3overlay/audio_player.sh \
/mp3overlay/Songs_list_source/abtal_el_digital.mp3 \
/mp3overlay/Songs_list_source/Some_Things_Never_Change.mp3 \
/mp3overlay/Songs_list_source/Toy_Story.mp3 \
/mp3overlay/Songs_list_source/Try_Everything.mp3 \
/mp3overlay/Songs_list_source/you_will_be_in_my_heart.mp3"


