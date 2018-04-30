#!/bin/bash
#SBATCH --mem-per-cpu=8192
#SBATCH --time=4:00:00
#SBATCH --job-name=ffscale
#SBATCH --mail-type=ALL
#SBATCH --error=ffscale-%j.err.txt
#SBATCH --output=ffscale-%j.out.txt

scale=4

display_usage() { 
    cat >&2 <<EOF
slurm-ffscale.sh inputvideo [-o outvideo] [-s scale] [-dryrun]
  With default paths:
    outvideo=<inputvideo>.scale<scale>.mp4
    scale=$scale
EOF
}
error() {
    echo "error: $1" >&2;
    echo -n "usage: "; display_usage;
    exit 1;
}
if [ $# -lt 1 ]; then error "Not enough arguments. Got $#, need 1"; fi

args=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -o) out="$2"; if [ -z "$2" ]; then error "Option $1: missing argument"; fi; shift 2;;
    -s) scale="$2"; if [ -z "$2" ]; then error "Option $1: missing argument"; fi; shift 2;;
    -d|-dryrun) dryrun='yes'; shift 1;;
    -h|-help|--help) display_usage; exit 0;;

    -*) error "Unknown option $1";;
    *) args+=("$1"); shift 1;;
  esac
done
if [ ${#args[@]} -ne 1 ]; then error "Incorrect number of parameters"; fi

in="${args[0]}"
out="${out-$in.scale$scale.mp4}"


/bin/date +"TIME BEGIN: %Y-%m-%d %H:%M:%S"

echo "SLURM-FFSCALE"
echo "  in=$in"
echo "  out=$out"
echo "  scale=$scale"
echo "  dryrun=$dryrun"
if [ ! -z "$dryrun" ]; then
    echo "Dryrun. exiting."
    exit 0
fi 

set -x

source /work/rmegret/rmegret/anaconda3/bin/activate

echo "### PREVIEW"
ffmpeg -i "$in" -vsync 0 -an -vf scale="in_w/${scale}:in_h/${scale}" \
   -vcodec libx264 -pix_fmt yuv420p -movflags faststart "$out"

/bin/date +"TIME END: %Y-%m-%d %H:%M:%S"

