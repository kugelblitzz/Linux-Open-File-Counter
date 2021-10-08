#!/bin/bash

source /root/.bash_profile

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROCESS_NAME="$(grep process_name $SCRIPT_DIR/config.ini  | awk -F '=' '{print $2}' ) "
PID="$(ps -ef | grep $PROCESS_NAME | grep -v grep | awk '{print $2}')"


re='^[0-9]+$'
if ! [[ $PID =~ $re ]] ; then
   echo "No Process named $PROCESS_NAME was found." >&2; exit 1
else
    FD="$(lsof -p $PID | wc -l)"
    CUR_TSTAMP="$(date +"%Y-%m-%d %T")"
    CUR_TSTAMP="$CUR_TSTAMP | Total File Descriptors for Process: $PROCESS_NAME , PID: $PID is $FD"
    echo $CUR_TSTAMP
    echo "$CUR_TSTAMP" >> $SCRIPT_DIR/openfiles.log
fi
