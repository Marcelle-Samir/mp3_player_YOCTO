do_deploy_append() {

    #Enable sound card
	sed -i '/#dtparam=audio/ c\dtparam=audio=on' ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
}
