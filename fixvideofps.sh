# Defaults

fps=20
dryrun=0

display_usage() { 
    cat <<EOF
fixvideofps [-d] [-fps FPS] FILES...
   Default: fps=$fps
   -d, --dryrun: just show
EOF
}
error() {
    echo "error: $1" >&2;
    echo -n "usage: "; display_usage;
    exit 1;
}
if [ $# -lt 1 ]; then 
   error "Not enough arguments: need 2, got $#"  
fi

args=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -fps) fps="$2"; if [ -z "$2" ]; then error "Missing parameter for option $1"; fi; shift 2;;
    -h|-help|--help) display_usage; exit 0;;
    -d|--dryrun) dryrun=1; shift 1;;
    -*) error "unknown option $1";;
    *) args+=("$1"); shift 1;;
  esac
done
# for i in "${args[@]}"; do echo \'$i\'; done
#if [ ${#args[@]} -ne 1 ]; then error "incorrect number of parameters"; fi

echo "fixvideofps: FILES=${args[@]}"
#set -x

for f in "${args[@]}"; do 
    echo "# JSON $f:"
    echo "<<<"
    cat "$f"
    echo "==="
    sed 's/"videofps":,/"videofps":20,/g;s/"realfps":,/"realfps":20,/g' "$f" 
    echo ">>>"
    if (( $dryrun == 0 )); then
        sed -i 's/"videofps":,/"videofps":20,/g;s/"realfps":,/"realfps":20,/g' "$f"
    fi
done

