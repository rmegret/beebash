#!/bin/bash

echo "#################### Job $1 ######################"
echo "Date = $(date)"
echo "###### ERR #####"
head -20 /work/rmegret/rmegret/tags/apriltag-$1.err.txt
echo "### ..."
tail -30 /work/rmegret/rmegret/tags/apriltag-$1.err.txt
echo "###### OUT #####"
head -20 /work/rmegret/rmegret/tags/apriltag-$1.out.txt
echo "### ..."
tail -30 /work/rmegret/rmegret/tags/apriltag-$1.out.txt
echo "################"
