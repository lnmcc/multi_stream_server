#!/bin/sh 

QUIT() {
	trap INT
	exit
}

INTSIG() {
	kill -s INT $ffmpid
	QUIT
}

trap "INTSIG" INT 

while [ true ];
do

	if [ ! -e /dev/video4 ]; then
		echo "***ERROR***: No USB Camera plugin!!!"
		QUIT
	fi

	ffmpeg -f video4linux2 -i /dev/video4 http://127.0.0.1:8090/feed_camera.ffm &
	ffmpid=$!
	echo "camera ffmpid="$ffmpid
	wait $ffmpid
done

