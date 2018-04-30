display_usage() { 
    cat <<EOF
do-tagjsonmerge.sh video family f0 f1
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
family="$2"
f0="$3"
f1="$4"

set +x

dir=/work/rmegret/rmegret/tags/${videoname%.*}/$2
mkdir -p $dir

wp=/work/rmegret/rmegret/utils/swatbotics_apriltag/python

echo "do-tagjsonmerge.sh $@"
set -x

"$wp"/tagjsonmerge.py -tags "$dir"/tagjson/tags_{:05d}.json -f0 $f0 -f1 $f1 -o "$dir"/tags_$vn_$family_${f0}-${f1}.json
#echo "Ctrl-C to stop monitoring"
#tail -f slurm_beetag_errors.txt slurm_beetag_output.txt
