# ffmpeg-merge-script

just a repo with a bash script used to make short edits with video and images

## how to use

first get the script, then prepare a txt file with the instructions inside then,

```bash
./ffmpeg_merge.sh instructions.txt framerate out.mp4
```

## instructions

they are used to tell the script what to do

exemple (no comments are allowed, they only are here to explain)

```txt
i:./image1.png 5        # the first character is always i or v, i if its an image, v if its a video
v:./video.mp4           # after it, there alays is a : then the path to the file. If the file is an
i:./image2.png 2:00     # image (i at the start) there will be a number at the end specifying the
v:./video2.mp4          # duration that it will be displayed for (in ffmpeg time notation: plain
i:./otherimage.png 0.5  # number of seconds or minutes:seconds and if needed decimals)
```
