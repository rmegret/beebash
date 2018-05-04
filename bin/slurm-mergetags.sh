#!/bin/bash
#SBATCH --mem-per-cpu=8192
#SBATCH --time=2:00:00
#SBATCH --job-name=mergetags
#SBATCH --mail-type=ALL
#SBATCH --workdir=/work/rmegret/rmegret/tags
#SBATCH --error=mergetag-%j.err.txt
#SBATCH --output=mergetag-%j.out.txt

vn="$1"
dir="$2"

f0=$3
f1=$4

#mkdir -p $dir

out="$dir/mergedtags/tags-${vn}-${f0}-${f1}.json"

set +x

wp=/work/rmegret/rmegret/utils/swatbotics_apriltag/python

source /work/rmegret/rmegret/anaconda3/bin/activate
export PATH=/work/rmegret/rmegret/anaconda3/bin:$PATH

echo "slurm-mergetags.sh $@"
#set -x

"$wp"/tagjsonmerge.py -tags "$dir"/rawtags/"$vn"/tagjson/tags_{:05d}.json -f0 $f0 -f1 $f1 -o "$out"
#echo "Ctrl-C to stop monitoring"
#tail -f slurm_beetag_errors.txt slurm_beetag_output.txt
