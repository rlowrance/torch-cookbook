# run map-reduce job and print output
INPUT=courant-abel-prize-winners.txt
JOB=countInput

# run the job
./map-reduce.sh $INPUT $JOB

# print the output file
cat $HOME/map-reduce-output/$INPUT.$JOB/part-00000
