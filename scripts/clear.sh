#!/bin/bash

#clears the last sample data recorded
source ../configFiles/HappyNeigbor.config

rm ${OUTPUT_FILE_PATH}/*.wav > /dev/null 2>&1
rm ${OUTPUT_FILE_PATH}/*.jpg > /dev/null 2>&1

