# run map reduce job using streaming interface
# USAGE:
# Change to the directory where your source code and scripts live. Then
# enter
#  ./map-reduce.sh INPUT JOB USERID? [READLIMIT]
# where
# INPUT     is the name of your input file in the Hadoop file system
#           If not in the Hadoop file system, must be in the local 
#           file system, in which case, it is copied to the Hadoop
#           file system.
# JOB       is the name of your map reduce job. The mapper command is
#             JOB-map.lua is the mapper command
#             JOB-reduce.lua is the reducer command
# USERID    not sure if this is needed. Try to eliminate it
# READLIMIT for compatibility with your local map-reduce job runner.
# 
# The script copies the output of the job from the Hadoop file system
# to $HOME/map-reduce-output

# capture command line arguments
INPUT=$1
JOB=$2
USERID=$3  # NOT NEEDED
READLIMIT=$4  # NOT USED

# input and output paths
INPUT_PATH=/home/$USER/$INPUT
OUTPUT_DIR_HADOOP=$INPUT.$JOB
OUTPUT_DIR_LOCAL=$HOME/map-reduce-output/$OUTPUT_DIR

# where Hadoop lives
HADOOP_HOME=/usr/lib/hadoop
STREAMING="hadoop-streaming-1.0.3.16.jar"

# 5: copy test file to the hadoop file system if it is not already there
hadoop fs -test -e $INPUT
if [ $? -ne 0 ]
then
  echo copying input from local file system to hadoop file system
  hadoop fs -copyFromLocal $INPUT $INPUT
else
  echo input file already in the hadoop file system
fi


# 6: delete output directory from previous run if it exists
hadoop fs -test -e $OUTPUT_DIR_HADOOP
if [ $? -eq 0 ]  
then
  echo deleting output directory: $OUTPUT_DIR_HADOOP
  hadoop fs -rmr $OUTPUT_DIR_HADOOP
else
  echo output directory not in the hadoop file system
fi

# 7: run the streaming job; it will create the output directory
echo starting hadoop streaming job
hadoop jar $HADOOP_HOME/contrib/streaming/$STREAMING \
 -file *.lua \
 -mapper $PWD/$JOB-map.lua \
 -reducer $PWD/$JOB-reduce.lua \
 -input $INPUT \
 -output $OUTPUT_DIR_HADOOP

# 8: copy output file to home directory
# delete output directory if it already exists
# We delete in case it has old content that is not overwritten by copyToLocal
if [ -a $OUTPUT_DIR_LOCAL ]
then
  # local output directory exists, so delete it
  cd $OUTPUT_DIR_LOCAL; rm -rf -- $OUTPUT_DIR_LOCAL
fi

mkdir -p $OUTPUT_DIR_COPY  # copyToLocal wants the directory to already exist
hadoop fs -copyToLocal $OUTPUT_DIR_HADOOP $OUTPUT_DIR_LOCAL

# 9: list output dir
echo LOCAL OUTPUT DIRECTORY
ls $OUTPUT_DIR_LOCAL

# 10: print main output file
#echo FIRST OUTPUT FILE part-00000
#cat $TO/part-00000

