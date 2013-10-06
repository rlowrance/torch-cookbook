# run map-reduce locally

# capture arguments
INPUT=$1
JOB=$2
READLIMIT=$3

# directory for local map-reduce output
LOCAL_MAP_REDUCE_OUTPUT=map-reduce-output-local

# do the work
./$JOB-map.lua $READLIMIT < $INPUT | \
  sort -k 1 | \
  ./$JOB-reduce.lua > $LOCAL_MAP_REDUCE_OUTPUT/$INPUT.$JOB


