display_usage() { 
    cat <<EOF
do-apriltag.sh video family f0 f1 [fps]
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

set -x

video="$1"
videoname="${1##*/}"
family="$2"
f0="$3"
f1="$4"
fps=${5:-20} # 20 fps by default
dir=/work/rmegret/rmegret/tags/${videoname%.*}/$2
mkdir -p $dir

echo "do-apriltags.sh $@"

sbatch -J $family-$f0-$f1-$videoname /work/rmegret/rmegret/utils/bash/slurm-apriltag.sh "$dir" "$video" "$family" $f0 $f1 $fps
#echo "Ctrl-C to stop monitoring"
#tail -f slurm_beetag_errors.txt slurm_beetag_output.txt
