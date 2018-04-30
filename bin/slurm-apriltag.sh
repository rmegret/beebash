#!/bin/bash
#SBATCH --mem-per-cpu=8192
#SBATCH --time=8:00:00
#SBATCH --job-name=tags
#SBATCH --mail-type=ALL
#SBATCH --workdir=/work/rmegret/rmegret/tags
#SBATCH --error=apriltag-%j.err.txt
#SBATCH --output=apriltag-%j.out.txt
#SBATCH --cpus-per-task=4

family=$3
f0=$4 #  f0=$1, or 0 if not defined
f1=$5 # f1=$2, or 10 if not defined
video=${2}
dir="${1}"
fps=$6
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

export OMP_NUM_THREADS=4

echo "SLURM-APRILTAG" >&2
echo "  dir=$dir" >&2
echo "  video=$video" >&2
echo "  family=$family" >&2
echo "  f0,f1=$f0,$f1" >&2
echo "  fps=$fps" >&2
echo "  step=$step" >&2
echo "  SLURM job id=$id, count=$SLURM_ARRAY_TASK_COUNT" >&2
echo "  ff0=$ff0,ff1=$ff1" >&2
echo "  OMP_NUM_THREADS=$OMP_NUM_THREADS" >&2

#set -x

mkdir -p "$dir"
cd "$dir"

source /work/rmegret/rmegret/anaconda3/bin/activate "root"

echo "slurm-apriltag.sh: Launching ${script}..." >&2

echo "  OMP_NUM_THREADS=$OMP_NUM_THREADS" >&2

"$PYTHON" "$script" -V "$video" -F $family -f0 $ff0 -f1 $ff1 -1 -D=0 -fps $fps -t 4

echo "slurm-apriltag.sh: DONE" >&2

/bin/date +"TIME END: %Y-%m-%d %H:%M:%S"

