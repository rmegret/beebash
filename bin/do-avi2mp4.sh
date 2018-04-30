display_usage() { 
    cat <<EOF
do-avi2mp4.sh video [-dryrun]
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

args=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -d|-dryrun) dryrun='yes'; shift 1;;
    -h|--help|-help) display_usage; exit 0;;

    -*) error "unknown option $1";;
    *) args+=("$1"); shift 1;;
  esac
done
# for i in "${args[@]}"; do echo \'$i\'; done
if [ ${#args[@]} -ne 1 ]; then error "Incorrect number of parameters"; fi



set -x

videoin="${args[0]}"
video="$(readlink -f "${videoin}")"  # Find absolute path
videofile="${video##*/}"
videoname="${videofile%.*}"
outdir=/work/rmegret/rmegret/videos/Gurabo

videodate=${videoname##*_}

if [ ! -z $dryrun ]; then
    echo "Dryrun. Aborting..."
    exit 0
fi

mkdir -p $outdir

sbatch -J avi2mpg-$videodate /work/rmegret/rmegret/utils/bash/slurm-avi2mpg.sh "$video" -o "$outdir"
#echo "Ctrl-C to stop monitoring"
#tail -f slurm_beetag_errors.txt slurm_beetag_output.txt
