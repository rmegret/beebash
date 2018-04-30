#!/bin/bash
#SBATCH --mem-per-cpu=8192
#SBATCH --time=0:20:00
#SBATCH --job-name=cleantags
#SBATCH --mail-type=ALL
#SBATCH --workdir=/work/rmegret/rmegret/tags
#SBATCH --error=cleantag-%j.err.txt
#SBATCH --output=cleantag-%j.out.txt

display_usage() { 
    cat <<EOF
do-cleantags.sh video
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

shift $#

echo "video=$video"
echo "vn='$vn'"

dir=/work/rmegret/rmegret/tags/${vn}
#mkdir -p $dir

out=/work/rmegret/rmegret/tags/Tags/

set -x

wp=/work/rmegret/rmegret/utils/swatbotics_apriltag/python

source /work/rmegret/rmegret/anaconda3/bin/activate
export PATH=/work/rmegret/rmegret/anaconda3/bin:$PATH

python3 /work/rmegret/rmegret/utils/tag_cleaner2/cleaner.py \
   -i /work/rmegret/rmegret/tags/$vn/tags-$vn-0-72100.json \
   -o /work/rmegret/rmegret/tags/Tags/Tags-$vn.json \
   -ids [13,14,15,16] -hm 2 -bx [175,30,2305,1240];
