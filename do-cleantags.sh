display_usage() { 
    cat <<EOF
do-cleantags.sh video [family f0 f1]
EOF
}
error() {
    echo "error: $1" >&2;
    echo -n "usage: "; display_usage;
    exit 1;
}
if [ $# -lt 1 ]; then 
   error "Not enough arguments: need 1, got $#"  
fi

video="$1"
videoname="${1##*/}"
vn=${videoname%.*}
family="${2:-tag25h5inv}"  # Default=tag25h5inv
f0="${3:-0}"      # Default=0"
f1="${4:-72100}"  # Default=72100"

#set +x

dir=/work/rmegret/rmegret/tags/${videoname%.*}/$2
#mkdir -p $dir

wp=/work/rmegret/rmegret/utils/swatbotics_apriltag/python

echo "do-cleantags.sh $@"
echo "Parameters:"
echo "  video=$video"
echo "  family=$family"
echo "  f0=$f0"
echo "  f1=$f1"
echo "Calling /work/rmegret/rmegret/utils/bash/slurm-cleantags.sh..."
#set -x

sbatch -J cleantags-$videoname /work/rmegret/rmegret/utils/bash/slurm-cleantags.sh "$video" 

