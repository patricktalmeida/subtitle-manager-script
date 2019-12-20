#!/bin/bash

##########################################################################################################
#  This script is supposed to be put as a daemon or executed on launch and the while will do the rest    #
#                                                                                                        #
#  It will search for an .srt subtitle on \$DOWNLOAD_PATH and copy it to it's right folder to stay beside#
#  the epsode that toy downloaded.                                                                       #
#                                                                                                        #
#  DO NOT FORGET to download the subtitle with the same name of the episode/movie before the extension   #
#                                                                                                        #
#  If used as dameon edit to remove the   while                                                          #
#                                                                                                        #
##########################################################################################################

DOWNLOAD_PATH=/subtitles
DIR_PATH=/mnt/sickrage-data

set +x

findSubLocation() {
        SERIES_DIRECTORY=$(find $DIR_PATH -type d | rev | cut -d / -f1 | grep -o '..E..S.*' | rev)
        array=$(echo $SERIES_DIRECTORY | sed 's/\s/\n/g')
        SUB_NAME=$(find $DOWNLOAD_PATH -iname "*.srt" | rev | cut -d / -f1 | grep -o '..E..S.*' | rev | head -n1)
}

moveSubtitle() {
    if [ -f $DOWNLOAD_PATH/$SERIE.srt ]
    then
        findSubLocation;
        for i in ${array[@]}
        do
            MKV_REAL_NAME=$(find $DIR_PATH/$i* -name "*.mkv" | rev | cut -f 2- -d '.' | rev | cut -d/ -f5 | head -n 1)
            if [[ $i = $SUB_NAME ]]; then
                    REAL_DIR=$(find $DIR_PATH/$i* -type d | cut -d / -f4 | head -n1)
                    mv $DOWNLOAD_PATH/$SERIE.srt $DIR_PATH/$REAL_DIR/$MKV_REAL_NAME.srt 2> /errorlog
            fi
        done
    fi
}

watchDownloadsDirectory() {
    while true; do
        SERIE=$(find $DOWNLOAD_PATH -name "*.srt" | rev | cut -f 2- -d '.' | rev | cut -d/ -f3 | head -n 1)
        if [[ $SERIE != '' ]]; then
            moveSubtitle;
        fi
        sleep 2
    done
}

watchDownloadsDirectory;
moveSubtitle;
