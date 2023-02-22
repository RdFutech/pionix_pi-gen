#!/bin/bash

UPDATE_CHANNEL="unstable"

FN=${1%.*}

META="$FN.meta"
HWID=`jq -r ".update.hwid" $META`
VERSION=`jq -r ".update.version" $META`

echo "Uploading $FN (HWID $HWID/Version $VERSION) to pionix@pionix-update.de/public_html/${HWID}/${UPDATE_CHANNEL}"

sftp -oBatchMode=no -b - pionix@pionix-update.de << EOF
   cd public_html
   -mkdir ${HWID}
   cd ${HWID}
   -mkdir ${UPDATE_CHANNEL}
   cd ${UPDATE_CHANNEL}
   -rm *
   put "$FN.pnx"
   put "$FN.meta"
   put "$FN.meta" "current.meta"
   put "$FN.img.gz"
   put "$FN.img.gz" "current.img.gz"
   bye
EOF
