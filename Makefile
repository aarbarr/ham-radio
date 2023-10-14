VAC_NAME=vac-aaron
VAC_ID_DIR=./tmp/vac
# VAC_ID_FILE_NAME=${VAC_NAME}.id
# VAC_ID_FILE_PATH=${VAC_ID_DIR}/${VAC_ID_FILE_NAME}


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

.PHONY: link-gqrx
link-gqrx: create-vac
	@pw-link GQRX:output_FL vac-aaron:playback_FL
	@pw-link GQRX:output_FR vac-aaron:playback_FR


# .PHONY: link-wsjtx
# link-wsjtx:
# 	@pw-link vac-aaron:playback_FL
# 	@pw-link vac-aaron:playback_FR


# .PHONY: link-js8call
# link-js8call:
# 	@pw-link GQRX:output_FL vac-aaron:playback_FL
# 	@pw-link GQRX:output_FR vac-aaron:playback_FR


.PHONY: link
link:
	@$(MAKE) create-vac
	@$(MAKE) link-gqrx
#	@$(MAKE) link-wsjtx


################################################################################
# unlink
#


.PHONY: unlink-dummy
unlink-dummy:
	@pw-link --disconnect speech-dispatcher-dummy:output_FL alsa_output.pci-0000_00_1f.3.hdmi-stereo:playback_FL || true
	@pw-link --disconnect speech-dispatcher-dummy:output_FR alsa_output.pci-0000_00_1f.3.hdmi-stereo:playback_FR || true


.PHONY: unlink-gqrx
unlink-gqrx:
	@pw-link --disconnect GQRX:output_FL vac-aaron:playback_FL || true
	@pw-link --disconnect GQRX:output_FR vac-aaron:playback_FR || true


# .PHONY: unlink-wsjtx
# unlink-wsjtx:
# 	@pw-link --disconnect alsa_input.usb-046d_HD_Pro_Webcam_C920_2278A4AF-02.analog-stereo:capture_FL QtPulseAudio:10595:input_FL || true
# 	@pw-link --disconnect alsa_input.usb-046d_HD_Pro_Webcam_C920_2278A4AF-02.analog-stereo:capture_FR QtPulseAudio:10595:input_FR || true


# .PHONY: unlink-js8call
# unlink-js8call:
# 	@pw-link --disconnect alsa_input.usb-046d_HD_Pro_Webcam_C920_2278A4AF-02.analog-stereo:capture_FL QtPulseAudio:10595:input_FL || true
# 	@pw-link --disconnect alsa_input.usb-046d_HD_Pro_Webcam_C920_2278A4AF-02.analog-stereo:capture_FR QtPulseAudio:10595:input_FR || true


.PHONY: unlink
unlink:
#	@$(MAKE) unlink-js8call
	@$(MAKE) unlink-gqrx
	@$(MAKE) unlink-dummy
	@$(MAKE) delete-vac