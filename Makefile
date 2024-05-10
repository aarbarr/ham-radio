VAC_NAME=vac-aaron
VAC_ID_DIR=./tmp/vac
# VAC_ID_FILE_NAME=${VAC_NAME}.id
# VAC_ID_FILE_PATH=${VAC_ID_DIR}/${VAC_ID_FILE_NAME}

SPKR=alsa_output.pci-0000_00_1f.3.hdmi-stereo
DUMMY=speech-dispatcher-dummy
ESPEAKNG=speech-dispatcher-espeak-ng

VAC_ID=$$(pw-link -i | grep '${VAC_NAME}')


.PHONY: print-vac-id
print-vac-id:
	echo "VAC_ID=${VAC_ID}"


.PHONY: create-vac
create-vac:
	@if [ ! "${VAC_ID}" ]; then \
		echo "$$(pactl load-module module-null-sink media.class=Audio/Sink sink_name=${VAC_NAME} channel_map=stereo)"; \
	fi


.PHONY: delete-vac
delete-vac:
	@if [ "${VAC_ID}" ]; then \
		pw-cli destroy ${VAC_NAME}; \
	fi


################################################################################
# link
#

.PHONY: link-gqrx-vac
link-gqrx-vac: create-vac
	@pw-link GQRX:output_FL ${VAC_NAME}:playback_FL
	@pw-link GQRX:output_FR ${VAC_NAME}:playback_FR


.PHONY: link-firefox-spkr
link-firefox-spkr:
	@pw-link Firefox:output_FL ${SPKR}:playback_FL
	@pw-link Firefox:output_FR ${SPKR}:playback_FR


.PHONY: link-firefox-vac
link-firefox-vac:
	@pw-link Firefox:output_FL ${VAC_NAME}:playback_FL
	@pw-link Firefox:output_FR ${VAC_NAME}:playback_FR


.PHONY: link-vac-spkr
link-vac-spkr:
	@pw-link ${VAC_NAME}:monitor_FL ${SPKR}:playback_FL
	@pw-link ${VAC_NAME}:monitor_FR ${SPKR}:playback_FR


.PHONY: link
link:
	@$(MAKE) create-vac
	@$(MAKE) link-gqrx-vac
	@$(MAKE) link-firefox-vac


################################################################################
# unlink
#

.PHONY: unlink-espeakng-spkr
unlink-espeakng-spkr:
	@pw-link --disconnect ${ESPEAKNG}:output_FL ${SPKR}:playback_FL || true
	@pw-link --disconnect ${ESPEAKNG}:output_FR ${SPKR}:playback_FR || true


.PHONY: unlink-dummy-spkr
unlink-dummy-spkr:
	@pw-link --disconnect ${DUMMY}:output_FL ${SPKR}:playback_FL || true
	@pw-link --disconnect ${DUMMY}:output_FR ${SPKR}:playback_FR || true


.PHONY: unlink-firefox-spkr
unlink-firefox-spkr:
	@pw-link --disconnect Firefox:output_FL ${SPKR}:playback_FL || true
	@pw-link --disconnect Firefox:output_FR ${SPKR}:playback_FR || true


.PHONY: unlink-gqrx-vac
unlink-gqrx-vac:
	@pw-link --disconnect GQRX:output_FL ${VAC_NAME}:playback_FL || true
	@pw-link --disconnect GQRX:output_FR ${VAC_NAME}:playback_FR || true


# .PHONY: unlink-js8call
# unlink-js8call:
# 	@pw-link --disconnect alsa_input.usb-046d_HD_Pro_Webcam_C920_2278A4AF-02.analog-stereo:capture_FL QtPulseAudio:10595:input_FL || true
# 	@pw-link --disconnect alsa_input.usb-046d_HD_Pro_Webcam_C920_2278A4AF-02.analog-stereo:capture_FR QtPulseAudio:10595:input_FR || true


.PHONY: unlink
unlink:
	@$(MAKE) unlink-dummy-spkr


################################################################################
# setup
#

.PHONY: setup
setup:
	@$(MAKE) unlink-firefox-spkr
#	@$(MAKE) link-firefox-spkr
	@$(MAKE) link-firefox-vac
	@$(MAKE) link-vac-spkr