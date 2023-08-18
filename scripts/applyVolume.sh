#!/bin/bash

#appliying volume to the sample

source /home/pi/Documents/bashScripts/definitionsScripts/bashDefineColors.sh

INPUT_FILENAME=$1
OUTPUT_FILENAME=volume_sample.wav
VOLUME_TO_APPLY=$2

echo -e "${LIGHT_YELLOW}Applying Volume: ${WHITE}${VOLUME_TO_APPLY}${NC}"

#applying volume to the sample
sox -v "$VOLUME_TO_APPLY" "$INPUT_FILENAME" "$OUTPUT_FILENAME" 

#saving the output on to the original sample
mv "$OUTPUT_FILENAME" "$INPUT_FILENAME"
