#!/bin/bash
#SBATCH --mem-per-cpu=8192
#SBATCH --time=0:20:00
#SBATCH --job-name=cleantags
#SBATCH --mail-type=ALL
#SBATCH --workdir=/work/rmegret/rmegret/tags
#SBATCH --error=cleantag-%j.err.txt
#SBATCH --output=cleantag-%j.out.txt

vn="$1"
dir="$2"
#mkdir -p $dir

shift $#

#set -x

wp=/work/rmegret/rmegret/utils/swatbotics_apriltag/python

source /work/rmegret/rmegret/anaconda3/bin/activate
export PATH=/work/rmegret/rmegret/anaconda3/bin:$PATH

python3 /work/rmegret/rmegret/utils/tag_cleaner2/cleaner.py \
   -i $dir/mergedtags/${vn}/tags-$vn-0-72100.json \
   -o $dir/cleantags/Tags-$vn.json \
   -ids [13,14,15,16] -hm 2 -bx [175,30,2305,1240];
