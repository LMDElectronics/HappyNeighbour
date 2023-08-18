#!/bin/bash

#sample file denoiser

source /home/pi/Documents/bashScripts/definitionsScripts/bashDefineColors.sh

FILE_TO_DENOISE=$1
NOISE_PROFILE_FILE=$2
SENSITIVITY=$3
LPFILTER_LFREQ=$4
LPFILTER_HFREQ=$5

CLEAN_OUTPUT_FILENAME=clean_sample.wav
TRIMMED_NOISE_FILE=trimmed_noise_file.wav
FILTERED_OUTPUT_FILENAME=filtered_sample.wav

echo -e "${LIGHT_YELLOW}Denoising...${NC}"

#clean noise from the audio
sox "$FILE_TO_DENOISE" "$CLEAN_OUTPUT_FILENAME" noisered "$NOISE_PROFILE_FILE" "$SENSITIVITY" > /dev/null 2>&1

#applying lowpass filter up to 9K
if [ "$LPFILTER_LFREQ" == "0k" ] && [ "$LPFILTER_HFREQ" == "0k" ]
then
  #does not apply any lowpass filter
  echo -e "${LIGHT_YELLOW}Not applying LPF...${NC}"
  FILTERED_OUTPUT_FILENAME="$CLEAN_OUTPUT_FILENAME"
else
  #appliying low pass filter
  echo -e "${LIGHT_YELLOW}applying LPF... ${WHITE}Low freq ${LPFILTER_LFREQ} High freq ${LPFILTER_HFREQ}${NC}"
  sox "$CLEAN_OUTPUT_FILENAME" "$FILTERED_OUTPUT_FILENAME" sinc -n 32767 "$LPFILTER_LFREQ"-"$LPFILTER_HFREQ" > /dev/null 2>&1
fi

#renaming the output file clean to output file
mv "$FILTERED_OUTPUT_FILENAME" "$FILE_TO_DENOISE"

#cleaning temp data for the denoise filtering
if [ -z "$CLEAN_OUTPUT_FILENAME" ]
then
  sudo rm "$CLEAN_OUTPUT_FILENAME"
fi
