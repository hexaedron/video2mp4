#!/bin/bash

# Paths to binaries
FFMPEG=ffmpeg

LOGFILE=video2mp4.log

date > $LOGFILE

# Create the directories and make file name
function make_mp4_file_name()
{
   input_dir=$1
   output_dir=$2
   video_file=$3

   album_dir=$(basename "$input_dir")
   mp4_file=${video_file}.mp4
   mp4_file=${mp4_file/#${input_dir}/${output_dir}/${album_dir}/}
   mp4_dir=$(dirname "$mp4_file")
   $(mkdir -p "$mp4_dir")

   echo "$mp4_file"
}

# Recoursively convert video files
# from input_dir to output_dir.
# output_dir is created automatically.
function main()
{
   input_dir=$1
   output_dir=$2
   search_mask=$3
   
   if [[ -z "$input_dir" || -z "$output_dir" ]]; then
      echo "Usage: $0 <input_dir> <output_dir> [\"search_mask\"]"
      echo "Example: $0 /tmp/my/video /tmp/my/mp4 \"*.avi"\"
      exit 1
   fi

   if [[ -z search_mask ]]; then
      search_mask="*.mkv"
   fi
   
   OIFS=$IFS; IFS=$'\n'

   # Recursive processing of video files
   for video_file in $(find "$input_dir" -name "$search_mask" | sort); do
      video_base=`basename "$video_file"`
      echo "Processing '$video_base'..." >> $LOGFILE

      mp4_file=$(make_mp4_file_name "$input_dir" "$output_dir" "$video_file")
      cmd="$FFMPEG -i \"$video_file\" \"$mp4_file\""

      eval $cmd
   done
}

main "$@"

date >> $LOGFILE
