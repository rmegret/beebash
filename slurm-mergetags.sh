#!/bin/bash
#SBATCH --mem-per-cpu=8192
#SBATCH --time=2:00:00
#SBATCH --job-name=mergetags
#SBATCH --mail-type=ALL
#SBATCH --workdir=/work/rmegret/rmegret/tags
#SBATCH --error=mergetag-%j.err.txt
#SBATCH --output=mergetag-%j.out.txt

display_usage() { 
    cat <<EOF
slurm-mergetags.sh video family f0 f1
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

video="$1"
videoname="${1##*/}"
vn=${videoname%.*}
family="$2:-tag25h5inv"  # Default=tag25h5inv
f0="$3:-0"      # Default=0"
f1="$4:-72100"  # Default=72100"

dir=/work/rmegret/rmegret/tags/${videoname%.*}
#mkdir -p $dir

out="$dir/tags-${vn}-${f0}-${f1}.json"

set +x

wp=/work/rmegret/rmegret/utils/swatbotics_apriltag/python

source /work/rmegret/rmegret/anaconda3/bin/activate
export PATH=/work/rmegret/rmegret/anaconda3/bin:$PATH

echo "slurm-mergetags.sh $@"
set -x

"$wp"/tagjsonmerge.py -tags "$dir"/tagjson/tags_{:05d}.json -f0 $f0 -f1 $f1 -o "$out"
#echo "Ctrl-C to stop monitoring"
#tail -f slurm_beetag_errors.txt slurm_beetag_output.txt
