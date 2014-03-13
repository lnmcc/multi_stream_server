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

	ffmpeg  -i "rtsp://192.168.2.191:554/user=admin&password=admin&channel=1&stream=0.sdp"  http://localhost:8090/feed_net.ffm & 
	ffmpid=$!
	echo "net ffmpid="$ffmpid
	wait $ffmpid
done

