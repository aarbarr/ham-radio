#!/usr/bin/env bash


VAC_ID_DIR=$1
VAC_NAME=$2
VAC_ID_FILE_NAME=${VAC_NAME}.id
VAC_ID_FILE_PATH=${VAC_ID_DIR}/${VAC_ID_FILE_NAME}


if [ -f "${VAC_ID_FILE_PATH}" ]; then
    while read line; do
        name=$(echo "${line}" | awk '{ print $1 }')
        id=$(echo "${line}" | awk '{ print $2 }')
        echo "deleting virtual audio cable '${name}' with id=${id}"
        pw-cli destroy ${name}
    done <${VAC_ID_FILE_PATH}
    rm ${VAC_ID_FILE_PATH}
fi
