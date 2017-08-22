# Defaults
family=tag25h5inv
f0=0
f1=72100
fps=20
basedir=/work/rmegret/rmegret/tags


display_usage() { 
    cat <<EOF
do-apriltag.sh video [-f family] [-f0 f0] [-f1 f1] [-fps fps] [-o out_basedir] [-d]
  defaults:
  family=$family, f0=$f0, f1=$f1, fps=$fps, out_basedir=$basedir
  -d: dryrun
EOF
}
error() {
    echo "error: $1" >&2;
    echo -n "usage: "; display_usage;
    exit 1;
}
if [ $# -lt 4 ]; then 
   error "Not enough arguments: need 4, got $#"  
fi

args=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -f) family="$2"; if [ -z "$2" ]; then error "Missing parameter for option $1"; fi; shift 2;;
    -f0) f0="$2"; if [ -z "$2" ]; then error "Missing parameter for option $1"; fi; shift 2;;
    -f1) f1="$2"; if [ -z "$2" ]; then error "Missing parameter for option $1"; fi; shift 2;;
    -fps) fps="$2"; if [ -z "$2" ]; then error "Missing parameter for option $1"; fi; shift 2;;
    -h|-help|--help) display_usage; exit 0;;

    -*) error "unknown option $1";;
    *) args+=("$1"); shift 1;;
  esac
done
# for i in "${args[@]}"; do echo \'$i\'; done
if [ ${#args[@]} -ne 1 ]; then error "incorrect number of parameters"; fi


set -x

video="${args[0]}"
videoname="${1##*/}"
dir="$basedir/${videoname%.*}/$2"
mkdir -p $dir

echo "do-apriltags.sh $@"

sbatch -J $family-$f0-$f1-$videoname /work/rmegret/rmegret/utils/bash/slurm-apriltag.sh "$dir" "$video" "$family" $f0 $f1 $fps
#echo "Ctrl-C to stop monitoring"
#tail -f slurm_beetag_errors.txt slurm_beetag_output.txt
