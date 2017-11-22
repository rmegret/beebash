#!/bin/bash
#SBATCH --mem-per-cpu=8192
#SBATCH --time=8:00:00
#SBATCH --job-name=tags
#SBATCH --mail-type=ALL
#SBATCH --workdir=/work/rmegret/rmegret/tags
#SBATCH --error=apriltag-%j.err.txt
#SBATCH --output=apriltag-%j.out.txt

display_usage() { 
    cat <<EOF
slurm-apriltag.sh dir video family f0 f1 [fps] [step]
EOF
}
error() {
    echo "error: $1" >&2;
    echo -n "usage: "; display_usage;
    exit 1;
}
if [ $# -lt 5 ]; then error "Not enough arguments. Got $#, need 5"; fi

family=$3
f0=${4-0} #  f0=$1, or 0 if not defined
f1=${5-10} # f1=$2, or 10 if not defined
video=${2}
dir="${1}"
fps=${6:-20}
step=${7}

if [ -z $step ]; then
  id=0
  ff0=$f0
  ff1=$f1
else
  id=${SLURM_ARRAY_TASK_ID-0} ## Caution: default to 0, not ID-1
  ff0=$(expr $f0 + $step \* $id)
  ff1=$(expr $ff0 + $step - 1)
  ff1=$(($ff1>$f1?$f1:$ff1))
fi

/bin/date +"TIME BEGIN: %Y-%m-%d %H:%M:%S"

PYTHON=/work/rmegret/rmegret/anaconda3/bin/python3
script=/work/rmegret/rmegret/utils/swatbotics_apriltag/python/apriltagdetect.py

echo "SLURM-APRILTAG"
echo "  dir=$dir"
echo "  video=$video"
echo "  family=$family"
echo "  f0,f1=$f0,$f1"
echo "  fps=$fps"
echo "  step=$step"
echo "  SLURM job id=$id, count=$SLURM_ARRAY_TASK_COUNT"
echo "  ff0=$ff0,ff1=$ff1"

#set -x

mkdir -p "$dir"
cd "$dir"

source /work/rmegret/rmegret/anaconda3/bin/activate

#"$PYTHON" "$script" -V "$VIDEO" -I -f tagbeetag -f0 $f0 -f1 $f1 -1 -D=0
"$PYTHON" "$script" -V "$video" -F $family -f0 $ff0 -f1 $ff1 -1 -D=0 -fps $fps # -t 6

/bin/date +"TIME END: %Y-%m-%d %H:%M:%S"

