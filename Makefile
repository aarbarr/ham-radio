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
#	@if [ ! "${VAC_ID}" ]; then \
		echo "$$(pactl load-module module-null-sink media.class=Audio/Sink sink_name=${VAC_NAME} channel_map=stereo)" > ${VAC_ID_FILE_PATH}; \
	fi
	@if [ ! "${VAC_ID}" ]; then \
		echo "$$(pactl load-module module-null-sink media.class=Audio/Sink sink_name=${VAC_NAME} channel_map=stereo)"; \
	fi


.PHONY: delete-vac
delete-vac:
	@if [ "${VAC_ID}" ]; then \
		pw-cli destroy ${VAC_NAME}; \
	fi


.PHONY: link-gqrx
link-gqrx: create-vac
	@pw-link GQRX:output_FL vac-aaron:playback_FL
	@pw-link GQRX:output_FR vac-aaron:playback_FR


.PHONY: unlink-gqrx
unlink-gqrx:
	@pw-link --disconnect GQRX:output_FL vac-aaron:playback_FL
	@pw-link --disconnect GQRX:output_FR vac-aaron:playback_FR
