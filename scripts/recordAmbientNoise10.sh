#!/bin/bash

#recording ambient noise for 10 seconds script

clear

source /home/pi/Documents/bashScripts/definitionsScripts/bashDefineColors.sh
source ../configFiles/HappyNeigbor.config

FILE_OUTPUT=$1

if [ -z "$FILE_OUTPUT" ] 
then
  FILE_OUTPUT="${OUTPUT_AMBIENT_NOISE_FILE_PATH}/defaultNoiseFloor.wav"
fi

#recording audio file
echo -e "${LIGHT_RED}Recording ambient noise: ${NC}${WHITE}${FILE_OUTPUT}${NC}"

#record command
#rec -c1 -r 48000 ${FILE_OUTPUT} silence 1 0.1 0.5% 1 1.0 0.5% > /dev/null 2>&1
rec -c1 -r ${SAMPLES} ${FILE_OUTPUT} trim 1 11 #> /dev/null 2>&1


