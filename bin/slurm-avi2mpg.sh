#!/bin/bash
#SBATCH --mem-per-cpu=8192
#SBATCH --time=4:00:00
#SBATCH --job-name=avi2mpg
#SBATCH --mail-type=ALL
#SBATCH --workdir=/work/rmegret/rmegret/videos
#SBATCH --error=avi2mpg-%j.err.txt
#SBATCH --output=avi2mpg-%j.out.txt

args=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -i) dir_in="$2"; if [ -z "$2" ]; then error "Option $1: missing argument"; fi; shift 2;;
    -o) dir_out="$2"; if [ -z "$2" ]; then error "Option $1: missing argument"; fi; shift 2;;
    -d|-dryrun) dryrun='yes'; shift 1;;
    -h|-help|--help) display_usage; exit 0;;

    -*) error "Unknown option $1";;
    *) args+=("$1"); shift 1;;
  esac
done
if [ ${#args[@]} -ne 1 ]; then error "Incorrect number of parameters"; fi

in="${args[0]}"
video="${in##*/}"
dir_in="${in%/*}"
dir_out="${dir_out-/work/rmegret/rmegret/videos/2017-06-Gurabo}"

# Parse input video filename
# Template:
#   II_CC_L_YYMMDDhhmmss.avi, example: 29_02_R_170604090000.avi or 36_01_H_160715100000.avi
# where
#   II: backup index (number starting at 1 indexing a batch of backup videos)
#   CC: camera id (02 for Gurabo camera summer 2017)
#   L:  some letter?
#   YYMMDDhhmmss: timestamp of beginning of video
#   .avi: suffix

name="${video%.*}"  # Remove suffix
in2="${name#*_}" # Remove backup index II
videocamera="${in2%_?_*}" ## extract CC
videodate="${name#*_*_*_}"    ## extract date

videoout="C${videocamera}_${videodate}".mp4

#in="$dir_in/$video"
out="$dir_out/$videoout"

json="$out".info.json
preview="$out".preview.mp4

starttime=`echo "$videodate" | \
    sed -E 's,([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2}),\1-\2-\3T\4:\5:\6,g'`

framerate=`ffprobe -v error -select_streams v:0 \
    -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$in"`
fps=` echo $framerate | awk -F/ '{a=$1/$2; printf "%.16G",a}' `

/bin/date +"TIME BEGIN: %Y-%m-%d %H:%M:%S"

echo "SLURM-AVI2MP4"
echo "  in=$in"
echo "  video=$video"
echo "  dir_in=$dir_in"
echo "  dir_out=$dir_out"
echo "  in=$in"
echo "  out=$out"
echo "  preview=$preview"
echo "  json=$json"
echo "  fps=$fps"
echo "  starttime=$starttime"
echo "  dryrun=$dryrun"
if [ ! -z "$dryrun" ]; then
    exit 0
fi 

set -x

mkdir -p "$dirout"
cd "$dirout"

source /work/rmegret/rmegret/anaconda3/bin/activate

echo "### PREVIEW"
ffmpeg -y -skip_frame nokey -i "$in" -vsync 0 -an -vf scale="in_w/8:in_h/8","setpts=PTS/40" -vcodec libx264 -pix_fmt yuv420p -movflags faststart "$preview"

echo "### MP4"
ffmpeg -y -i "$in" -movflags faststart -an -vcodec copy "$out"

echo "{" > "$json"
echo '  "videofps":'$fps',' >> "$json"
echo '  "realfps":'$fps',' >> "$json"
echo '  "family":["tag25h5inv"],' >> "$json"
echo '  "starttime":"'$starttime'"' >> "$json"
echo "}" >> "$json"


/bin/date +"TIME END: %Y-%m-%d %H:%M:%S"

