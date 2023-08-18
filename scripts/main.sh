#!/bin/bash

# this script manages the process of:
# read needed config
# recording audio
# playing audio
# keep track of files for post analysis

source /home/pi/Documents/bashScripts/definitionsScripts/bashDefineColors.sh

#sample number
N=1 

#clear screen
reset

while true
do
  # 1- get configuration data
  source ../configFiles/HappyNeigbor.config
  
  # 2- start recording
  if [ -z $OUTPUT_FILENAME ]
  then
    OUTPUT_FILENAME=defaultAudio.wav    
  fi

  if [ -z $OUTPUT_FILE_PATH ]
  then
   OUTPUT_FILE_PATH=`pwd` 
   OUTPUT_FILE_PATH+="/"
  fi

  OUTPUT="$OUTPUT_FILE_PATH/$OUTPUT_FILENAME"

  ./recordAudio.sh "$OUTPUT" "$SAMPLES" 

  # 3- check if noise filter must be applied
  if [ "$NOISE_PROCESSING" == "YES" ]
  then    
    ./denoiseSample.sh "$OUTPUT" "$PROFILE_FILE" "$SENSITIVITY" "$LOWPASS_FILTER_LFREQ" "$LOWPASS_FILTER_HFREQ"
  fi

  # 4- check if synth tones should be added
  if [ "$ADD_TONE" == "YES" ]
      then
        ./applyToneToSample.sh "$OUTPUT" "$TONE_FREQ_HZ" "$SAMPLES" "$TONE_VOLUME_DB"
  fi  

  # 5 - check if gain must be applied
  if [ "$MODIFY_OUTPUT_FILE_VOLUME" == "YES" ]
  then     
    ./applyVolume.sh "$OUTPUT" "$OUTPUT_FILE_VOLUME"
  fi

  # 6- sleep before playing
  if [ ${SLEEP_SECONDS_BEFORE_PLAY} -ge "1" ]
  then    
    echo -e "${LIGHT_YELLOW}Sleeping for: ${WHITE}${SLEEP_SECONDS_BEFORE_PLAY}${NC} seconds"
    sleep ${SLEEP_SECONDS_BEFORE_PLAY}    
  fi

  # 7- playing audio
  if [ ! -z $PLAYING_DEVICE ]
  then 

    #check if sample should be played more than once
    if [ "$REPEAT_SAMPLE" == "YES" ] 
    then
 
      for(( i=0; i< "$TIMES_TO_REPEAT"; i++ ))
      do

       if [ "$USE_HEADER" == "YES" ]
       then     
        HEADER="$HEADER_OUTPUT_PATH/$HEADER_OUTPUT_FILENAME"
        ./playAudio.sh "$PLAYING_DEVICE" "$OUTPUT" "$HEADER"
       else          
        ./playAudio.sh "$PLAYING_DEVICE" "$OUTPUT"
       fi

       sleep "$REPEAT_SLEEP_TIME_IN_MS"

      done  

    else

      if [ "$USE_HEADER" == "YES" ]
      then     
        HEADER="$HEADER_OUTPUT_PATH/$HEADER_OUTPUT_FILENAME"
        ./playAudio.sh "$PLAYING_DEVICE" "$OUTPUT" "$HEADER"
       else          
        ./playAudio.sh "$PLAYING_DEVICE" "$OUTPUT"
      fi

    fi
  fi
  
  # 8- save current audio for statistics
  CURRENT_DATE_DIR=$(date '+%d_%m_%y')

  if [ ! -d "$OUTPUT_DATA_FILE_PATH/$CURRENT_DATE_DIR" ] 
  then
    sudo mkdir "$OUTPUT_DATA_FILE_PATH/$CURRENT_DATE_DIR" > /dev/null 2>&1
    sudo chmod 777 "$OUTPUT_DATA_FILE_PATH/$CURRENT_DATE_DIR" > /dev/null 2>&1    
  fi

  DATE=$(date '+%H_%M_%S')
  SAMPLE="sample${N}_${DATE}.wav"
  SAMPLEMP3="sample${N}_${DATE}.mp3"
  SPECTROGRAM_PNG="sample${N}_${DATE}.png"
  SPECTROGRAM_JPG="sample${N}_${DATE}.jpg"
  
  sox $OUTPUT -n spectrogram -o $SPECTROGRAM_PNG > /dev/null 2>&1

  convert $SPECTROGRAM_PNG -quality $SPECTROGRAM_JPG_QUALITY $SPECTROGRAM_JPG > /dev/null 2>&1
  rm $SPECTROGRAM_PNG > /dev/null 2>&1 

  mv "$OUTPUT" "$OUTPUT_DATA_FILE_PATH/$CURRENT_DATE_DIR/$SAMPLE" > /dev/null 2>&1
  mv "$SPECTROGRAM_JPG" "$OUTPUT_DATA_FILE_PATH/$CURRENT_DATE_DIR/$SPECTROGRAM_JPG" > /dev/null 2>&1
 
  # 9- convert wav file to mp3 file
  echo -e "${LIGHT_YELLOW}Compressing sample... ${NC}"
  lame -q0 -b128 "$OUTPUT_DATA_FILE_PATH/$CURRENT_DATE_DIR/$SAMPLE" "$OUTPUT_DATA_FILE_PATH/$CURRENT_DATE_DIR/$SAMPLEMP3" > /dev/null 2>&1

  echo -e "${LIGHT_BLUE}Stored Files: ${NC}"
  echo -e "  " "$SAMPLEMP3"
  echo -e "  " "$SPECTROGRAM_JPG"

  sudo rm "$OUTPUT_DATA_FILE_PATH/$CURRENT_DATE_DIR/$SAMPLE"

  #updating sample number
  N=$((N+1))

done

