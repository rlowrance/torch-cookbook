# run countInput map-reduce streaming job
# change to the directory that contains the source and shell file
# then run
#  ./countInput-run.sh

# 1: options to consider whilst debugging
#set -e     # stop at first non-zero return code
#set -x     # print each command before executing it

# 2: set control variables
INPUT_FILE="courant-abel-prize-winners.txt"
JOB_NAME="countInput"
USER_DIR="/user/$USER"
SRC=$PWD
MAPPER="${SRC}/${JOB_NAME}-map.lua"
REDUCER="${SRC}/${JOB_NAME}-reduce.lua"

# 3: input and output
# NOTES: $INPUT_FILE/$JOB_NAME as the output directory does not work because
# there is already a file $INPUT_FILE and there cannot be a directory with 
# the same name
INPUT_PATH=$USER_DIR/$INPUT_FILE
OUTPUT_DIR=$INPUT_FILE.$JOB_NAME
LOCAL_OUTPUT_DIR=$HOME/map-reduce-output/$OUTPUT_DIR

# 4: system default streaming jar
HADOOP_HOME=/usr/lib/hadoop
STREAMING="hadoop-streaming-1.0.3.16.jar"

# 5: copy test file to the hadoop file system if it is not already there
hadoop fs -test -e $INPUT_FILE
echo rc from test of input file=$?
if [ $? -ne 0 ]
then
  echo copying input from local file system to hadoop file system
  hadoop fs -copyFromLocal $INPUT_FILE $INPUT_FILE
else
  echo input file already in the hadoop file system
fi


# 6: delete output directory from previous run if it exists
echo about to test directory $OUTPUT_DIR
hadoop fs -ls
hadoop fs -test -e $OUTPUT_DIR
echo rc from test of output dir=$?
if [ $? -eq 0 ]  
then
  echo deleting output directory: $OUTPUT_DIR
  hadoop fs -rmr $OUTPUT_DIR
else
  echo output directory not in the hadoop file system
fi

# 7: run the streaming job; it will create the output directory
echo creating output dirctory using streaming interface
echo mapper=$MAPPER
echo reducer=$REDUCER
echo input path=$INPUT_PATH
echo output dir=$OUTPUT_DIR
hadoop jar $HADOOP_HOME/contrib/streaming/$STREAMING \
 -file *.lua \
 -mapper $MAPPER \
 -reducer $REDUCER \
 -input $INPUT_PATH \
 -output $OUTPUT_DIR

# 8: copy output file to home directory
FROM=$USER/$OUTPUT_DIR
FROM=$OUTPUT_DIR
TO=$HOME/map-reduce-output/$OUTPUT_DIR
echo copy output from $FROM 
echo copy output to $TO
if [ -a ~/map-reduce-output/$OUTPUT_DIR ] 
then
  # output directory exists, so delete it
  cd ~/map-reduce-output; rm -rf -- $OUTPUT_DIR # delete $TO directory
fi
mkdir -p $TO  # copyToLocal wants the directory to already exist
hadoop fs -copyToLocal $FROM $HOME/map-reduce-output/

# 9: list output dir
echo OUTPUT DIRECTORY
ls $TO

# 10: print main output file
echo FIRST OUTPUT FILE part-00000
cat $TO/part-00000
