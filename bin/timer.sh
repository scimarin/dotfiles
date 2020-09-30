timer() {
    local N=$1; shift
    (sleep $N && notify-send "${*:-BING}") &
    echo "timer set for $N"
}

timer $1 $2
