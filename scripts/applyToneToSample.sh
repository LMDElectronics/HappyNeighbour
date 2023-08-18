#!/bin/bash

source /home/pi/Documents/bashScripts/definitionsScripts/bashDefineColors.sh

INPUT_FILENAME=$1
TONE_FILENAME=tone.wav
TONE_FREQ=$2
SAMPLING_TIME=$3
TONE_DB=$4
MERGED_FILENAME=merged_sample.wav

SAMPLE_DURATION=`soxi -D "$INPUT_FILENAME"`
echo -e "${LIGHT_YELLOW}Sample Duration: ${WHITE}${SAMPLE_DURATION}"

#creating tone
sox -r "$SAMPLING_TIME" -n -b 16 -c 1 "$TONE_FILENAME" synth "$SAMPLE_DURATION" sin "$TONE_FREQ" vol "$TONE_DB"dB

#playing tone
#aplay -D hw:2,0 "$OUTPUT_FILENAME"

#mixing tone with sample
echo -e "${LIGHT_YELLOW}Mixing Tone... ${WHITE}${TONE_FREQ}Hz${NC}"
sox -m "$INPUT_FILENAME" "$TONE_FILENAME" "$MERGED_FILENAME"

mv "$MERGED_FILENAME" "$INPUT_FILENAME"
rm "$TONE_FILENAME"

