# run map-reduce job locally (without Hadoop)
set -x
cat courant-abel-prize-winners.txt | ./countInput-map.lua x | sort -k1 | ./countInput-reduce.lua
