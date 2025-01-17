#!/bin/bash
usage() { echo "Usage: $0 [-E -L -t <int> -s <d | m> -p <string>]"; exit 1; }

#E option excludes /etc/ directories
#L option excludes /var/log/ directories
#t <int> option sets how far back fxn looks for changes USE NEG INT
#s <d | m> option changes time scale to days or minutes
#p <string> option adds a file path to the list of directories to search

excludeETC=0
excludeVARLOG=0
filePath=""
duration=-1
scale="d"
possibleScales="dm"

while getopts "ELt:s:p:" arg
do
  case $arg in
    E)
      excludeETC=1
      ;;
    L)
      excludeVARLOG=1
      ;;
    t)
      duration=$OPTARG
      [ $OPTARG > 0 ] && duration=$(($OPTARG-$OPTARG*2))
      ;;
    p)
      filePath=$OPTARG
      ;;
    s)
      if [[ "$possibleScales" =~ "$OPTARG" ]]; then
        scale=$OPTARG
      else
        echo "OPTARG not in possible scales"
        
        usage
      fi
      ;;
    *)
      usage
      ;;
  esac
done

if [[ $scale == "d" ]]; then
  [ $excludeETC -eq 0 ] && find /etc/* -mtime $duration -print
  [ $excludeVARLOG -eq 0 ] && find /var/log/* -mtime $duration -print
  [[ -n "$filePath" ]] && find $filePath -mtime $duration -print
else
  [ $excludeETC -eq 0 ] && find /etc/* -mmin $duration -print
  [ $excludeVARLOG -eq 0 ] && find /var/log/* -mmin $duration -print
  [[ -n "$filePath" ]] && find $filePath -mtime $duration -print
fi

