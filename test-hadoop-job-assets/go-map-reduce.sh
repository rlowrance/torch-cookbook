# run map-reduce locally
./countInput-map.lua 2 < courant-abel-prize-winners.txt | sort -k 1 | ./countInput-reduce.lua > countInput-test-output

