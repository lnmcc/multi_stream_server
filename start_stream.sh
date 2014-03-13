#!/bin/sh 

QUIT() {
	trap INT
	trap TERM
	exit
}

INTSIG() {
	STOP_STREAM
	QUIT
}

START_STREAM() {
	./stream_net.sh &
	netpid=$!
	echo "net pid="$netpid

	./stream_camera.sh &
	camerapid=$!
	echo "camera pid="$camerapid

	./stream_tv.sh &
	tvpid=$!
	echo "tv pid="$tvpid
}

STOP_STREAM() {
	kill -s INT $ffserverpid
	kill -s INT $netpid
	kill -s INT $camerapid
	kill -s INT $tvpid
}

#Main
set -bm
trap "INTSIG" INT 

while [ true ];
do
	ffserver  -f /etc/ffserver.conf &
	ffserverpid=$!
	echo "ffserver pid="$ffserverpid
	START_STREAM
	wait $ffserverpid
	STOP_STREAM	
	sleep 5
done

QUIT

#end

#ffmpeg  -re  -fix_sub_duration   -i "rtsp://192.168.2.191:554/user=admin&password=admin&channel=1&stream=0.sdp"  -vcodec libx264  -qmin 3 -qmax 31 -qdiff 4 -me_range 16 -keyint_min 25 -qcomp 0.6 -b:v 1000K   http://localhost:8090/feed1.ffm  
#while [ true ]
#do
#find /root/ffmpeg/video -name "*.mov" -print  | xargs  -I {}   ./ffmpeg  -re  -fix_sub_duration -i {}   -vcodec libx264  -qmin 3 -qmax 31 -qdiff 4 -me_range 16 -keyint_min 25 -qcomp 0.6 -b:v 9000K    http://localhost:8090/feed1.ffm
#done

#cat ./video/lastexorcism-tlr2_h1080p.mov ./video/mollystheory-tlr1_h480p.mov  ./video/21over-tlr1_h1080p.mov  | ./ffmpeg  -re  -fix_sub_duration -i -   -vcodec libx264  -qmin 3 -qmax 31 -qdiff 4 -me_range 16 -keyint_min 25 -qcomp 0.6 -b:v 9000K    http://localhost:8090/feed1.ffm


#while [ true ]
#do

#./ffmpeg   -re  -fix_sub_duration -i  ./video/lastexorcism-tlr2_h1080p.mov  -vcodec libx264  -qmin 3 -qmax 31 -qdiff 4 -me_range 16 -keyint_min 25 -qcomp 0.6 -b:v 9000K    http://localhost:8090/feed1.ffm


#./ffmpeg   -re -fix_sub_duration -i  ./video/mollystheory-tlr1_h480p.mov  -vcodec libx264  -qmin 3 -qmax 31 -qdiff 4 -me_range 16 -keyint_min 25 -qcomp 0.6 -b:v 9000K    http://localhost:8090/feed1.ffm

#./ffmpeg   -re -fix_sub_duration -i  ./video/21over-tlr1_h1080p.mov  -vcodec libx264  -qmin 3 -qmax 31 -qdiff 4 -me_range 16 -keyint_min 25 -qcomp 0.6 -b:v 9000K    http://localhost:8090/feed1.ffm

#./ffmpeg   -re -fix_sub_duration -i  ./video/cxqd.avi  -vcodec libx264  -qmin 3 -qmax 31 -qdiff 4 -me_range 16 -keyint_min 25 -qcomp 0.6 -b:v 9000K    http://localhost:8090/feed1.ffm

#./ffmpeg  -re  -fix_sub_duration  -i  ./video/fairhaven-tlr1_h1080p.mov  -vcodec libx264  -qmin 3 -qmax 31 -qdiff 4 -me_range 16 -keyint_min 25 -qcomp 0.6 -b:v 9000K    http://localhost:8090/feed1.ffm
#done
