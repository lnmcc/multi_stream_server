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
	if [ ! -e /dev/video0 ]; then
		echo "***ERROR***: No tv card plugin!!!"
		QUIT
	fi

    ffmpeg -f video4linux2 -i /dev/video0 -f alsa -i hw:0,0  http://127.0.0.1:8090/feed_tv.ffm &
	ffmpid=$!
	echo "TV ffmpid="$ffmpid
	wait $ffmpid
done

