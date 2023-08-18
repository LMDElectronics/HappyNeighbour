#!/bin/bash

#playing audio script

source /home/pi/Documents/bashScripts/definitionsScripts/bashDefineColors.sh

HW=$1
FILE_INPUT=$2
HEADER_FILE=$3

#echo "$HW"
#echo "$FILE_INPUT"

if [ -z "$3" ] 
then
  echo -e "${LIGHT_YELLOW}No sound header used..."
else  
  echo -e "${LIGHT_YELLOW}Header Used: ${WHITE}${HEADER_FILE}"
fi

echo -e "${LIGHT_GREEN}Playing: ${WHITE}${FILE_INPUT}${NC}"

#play the header file if it exists
if [ ! -z $HEADER_FILE ] 
then
  aplay -D ${HW} ${HEADER_FILE} > /dev/null 2>&1
fi

aplay -D ${HW} ${FILE_INPUT} > /dev/null 2>&1

echo -e "${LIGHT_YELLOW}Playing finished..."
