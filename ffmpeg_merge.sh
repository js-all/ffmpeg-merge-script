#!/bin/sh
file=$1
toRm=()
toConcat=()
while read p; do
  type=$(echo $p | head -c 1)
  tsFile=""
  if [ $type = "i" ]; then
    typelessString=$(echo $p | sed "s/:/>/" | cut -d'>' -f2)
    duration=${typelessString##* }
    image=${typelessString% *}
    imageMp4="$image.mp4"
    imageTs="$image.ts"
    ffmpeg -hide_banner -loglevel warning -loop 1 -framerate $2 -i $image -c:v libx264 -t $duration -pix_fmt yuv420p $imageMp4
    toRm+=($imageMp4)
    ffmpeg -hide_banner -loglevel warning -i $imageMp4 -c copy -bsf:v h264_mp4toannexb -f mpegts $imageTs
    toRm+=($imageTs)
    tsFile=$imageTs
  elif [ $type = "v" ]; then
    video=$(echo $p | sed "s/:/>/" | cut -d'>' -f2)
    videoTs="$video.ts"
    ffmpeg -hide_banner -loglevel warning -i $video -c copy -bsf:v h264_mp4toannexb -f mpegts $videoTs
    toRm+=($videoTs)
    tsFile=$videoTs
  fi
  toConcat+=($tsFile)
done <$file

function join_by { local IFS="$1"; shift; echo "$*"; }

concat="concat:$(join_by "|" "${toConcat[@]}")"
echo $concat
ffmpeg -hide_banner -loglevel warning -i $concat -c copy -bsf:a aac_adtstoasc $3

for i in "${toRm[@]}"; do
  rm $i
done
