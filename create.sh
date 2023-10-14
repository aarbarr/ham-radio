#!/usr/bin/env bash


VAC_ID_DIR=$1
VAC_NAME=$2
VAC_ID_FILE_NAME=${VAC_NAME}.id
VAC_ID_FILE_PATH=${VAC_ID_DIR}/${VAC_ID_FILE_NAME}

#
echo "VAC_ID_DIR=${VAC_ID_DIR}"
echo "VAC_NAME=${VAC_NAME}"

# create a virtual audio cable called 'vac-aaron'
if [ ! -d ${VAC_ID_DIR} ]; then
    mkdir -p ${VAC_ID_DIR}
fi
if [ ! -f ${VAC_ID_FILE_PATH} ]; then
    touch ${VAC_ID_FILE_PATH}
fi

UUID=$(uuidgen | cut -c 2-7)

# crate the virtual audio cable
VAC_ID=$(pactl load-module module-null-sink media.class=Audio/Sink sink_name=${VAC_NAME}-${UUID} channel_map=stereo)

# record the virtual audio cable id
echo "${VAC_NAME}-${UUID}     ${VAC_ID}" >> ${VAC_ID_FILE_PATH}
cat ${VAC_ID_FILE_PATH}
