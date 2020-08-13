#!/bin/bash


file="${1}"
airtime_conf_path=/etc/airtime/airtime.conf
api_key=$(grep api_key ${airtime_conf_path} | awk '{print $3;}' )

if [[ $file = *.wav ]];then
	echo "convert to mp3"
	mkdir -p /tmp/libreimport

	newFile=/tmp/libreimport/$(basename "$file" .wav).mp3
	ffmpeg -i "$file" -codec:a libmp3lame -qscale:a 0 "${newFile}"
	file="${newFile}"
fi


python - << EOF

import sys
import json
import time
import select
import signal
import os
import logging
import urllib3
pathname = "${file}"
api_key = "${api_key}"
url = 'http://studio.radioangrezi.de/rest/media'
http = urllib3.PoolManager()
with open (pathname, "rb") as audiofile:
    audio_data = audiofile.read()
path, filename = os.path.split(pathname)
authstring = str(api_key) + ':'
print(filename)
headers = urllib3.util.make_headers(basic_auth=authstring)
fields = {'file': (filename, audio_data)}
r = http.request('POST', url, headers=headers, fields=fields)
print(r.status)
#TODO we might want to parse r.text to determine if the upload status = 1 and was successful then delete

EOF
