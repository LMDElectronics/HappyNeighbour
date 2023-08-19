#!/bin/bash

#creating noise profile from file

clear

source /home/pi/Documents/bashScripts/definitionsScripts/bashDefineColors.sh
source ../configFiles/HappyNeigbor.config

SOURCE_AMBIENT_NOISE_FILE=$1
FILE_OUTPUT=$2

if [ -z "$SOURCE_AMBIENT_NOISE_FILE" ] 
then
  echo -e "${LIGHT_YELLOW}No file input found, exiting...${NC}"
  exit
else
  echo -e "${LIGHT_YELLOW}Creating profile from: ${WHITE}${SOURCE_AMBIENT_NOISE_FILE}${NC}"
fi

if [ -z "$FILE_OUTPUT" ] 
then
  FILE_OUTPUT="${OUTPUT_PROFILE_FILE_PATH}/defaultNoiseProfile.profile"
fi

echo -e "${LIGHT_GREEN}Creating noise profile: ${NC}${WHITE}${FILE_OUTPUT}${NC}"

sox ${SOURCE_AMBIENT_NOISE_FILE} -n noiseprof ${FILE_OUTPUT}

