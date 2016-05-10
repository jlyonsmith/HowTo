# LibAv

_NOTE_: A 3 hour movie is 10800 seconds.

Extract a section of the video, with audio:

    avconv -ss '00:04:14' -t '00:00:10' -i video.mp4 -y clip.mp4

Extract a section of the video, no audio:

    avconv -ss '00:04:14' -t '00:00:10' -i video.mp4 -an -y clip.mp4

Extract only I-frames to PNG's:
	
	avconv -ss '00:04:14' -t '00:00:10' -i StarWarsIV.mp4 -f image2 -vf "select='eq(pict_type,PICT_TYPE_I)'" -vsync vfr -an thumb%04d.png

Extract 10 seconds, one frame per second to JPEG's, medium quality (0 - 31), overwrite output files:
    
    avconv -ss '00:04:14' -t '00:00:10' -i StarWarsIV.mp4 -f image2 -q:v 16 -r 1 -y images/img%05d.jpg

Extract 10 seconds, one frame per second to JPEG's, medium quality (0 - 31), overwrite output files, scale output to 640 pixels wide:
    
    avconv -ss '00:04:14' -t '00:00:10' -i StarWarsIV.mp4 -r 1 -q:v 16 -vf scale=640:-1 -y img%05d.jpg

Extract one frame per second to MP4, no audio, same overall length movie, overwrite output files:
	
	avconv -ss '00:04:14' -t '00:00:10' -i StarWarsIV.mp4 -r 1 -an -y clip.mp4

Extract a single frame, overwrite output files:

	avconv -ss '00:04:20' -i StarWarsIV.mp4 -vframes 1 -f image2 -y -an 'imagefile%03d.jpg'

Extract the PTS's (Presentation TimeStamps) of all the I-frames in the video:

    avprobe -select_streams v -show_frames -print_format compact -v quiet video.mp4 | awk '/pict_type=I/{ print $0; }'
