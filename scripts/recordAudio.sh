#!/bin/bash

#recording audio script

source /home/pi/Documents/bashScripts/definitionsScripts/bashDefineColors.sh

FILE_OUTPUT=$1
SAMPLING_TIME=$2

if [ -z "$FILE_OUTPUT" ] 
then
  FILE_OUTPUT=`pwd`
  FILE_OUTPUT+="/defaultRecording.wav" 
fi

#echo the sound card available
#echo -e " ${WHITE}Show info about the sound cards available:${NC}"]
#cat /proc/asound/cards
#echo -e " "

#echo the /etc/asound.config
#FILE=/etc/asound.conf
#echo -e "${WHITE}Show file config ${FILE}:${NC}"
#cat ${FILE}
#echo -e " "

#echo the /home/<user>/.asounddrc
#FILE=.asoundrc
#echo -e "${WHITE}Show file config ${FILE}:${NC}" 
#cd
#cat ${FILE}

#recording audio file
echo -e "${LIGHT_RED}Recording File: ${NC}${WHITE}${FILE_OUTPUT}${NC}"

#record command

#parameter explanation
#
# start recording:
#  "silence 1"  will be trimmered until a sound is 
#  "1.5%" of the sample value is heard for at least
#  "0.1" seconds 
#
# stop recording:
#  "1"  trim all silence after the sample value is 
#  "1.5%" below the threshold after
#  "1" seconds 

#rec -c1 -r ${SAMPLING_TIME} ${FILE_OUTPUT} silence 1 0.1 1.5% 1 1.0 1.5% > /dev/null 2>&1
rec -c1 -r ${SAMPLING_TIME} ${FILE_OUTPUT} silence 1 0.1 1.0% 1 1.0 1.0% > /dev/null 2>&1
