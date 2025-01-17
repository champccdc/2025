#!/bin/bash
usage() { echo "Usage: $0 [-E -L -t <int> -s <d | m> -p <string> -f <file> -o <file>]"; exit 1; }

#i know this looks absolutely atrocious but too lazy to see how to compact it

#E option excludes /etc/ directories
#L option excludes /var/log/ directories
#t <int> option sets how far back fxn looks for changes USE NEG INT
#s <d | m> option changes time scale to days or minutes
#p <string> option adds a file path to the list of directories to search
#f option requires a file that contains a list of directories to search seperated by newline
#o option takes a file to output results to instead of printing to console
#FUTURE WORK: sort/filter entries by priority

excludeETC=0
excludeVARLOG=0
filePath=""
fileName=""
outputFile=""
duration=-1
scale="d"
possibleScales="dm"

while getopts "ELt:s:p:f:o:" arg
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
      [ $OPTARG -gt 0 ] && duration=$(($OPTARG-$OPTARG*2))
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
    f)
      fileName=$OPTARG
      ;;
    o)
      outputFile=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done

function getEditedFiles()
{
  if [[ $scale == "d" ]]; then
    [ $excludeETC -eq 0 ] && find /etc/* -mtime $duration -print
    [ $excludeVARLOG -eq 0 ] && find /var/log/* -mtime $duration -print
    [[ -n "$filePath" ]] && find $filePath -mtime $duration -print
    if [[ -n "$fileName" ]]; then
      while read -r line; do
        find $line -mtime $duration -print
      done < $fileName
    fi
  else
    [ $excludeETC -eq 0 ] && find /etc/* -mmin $duration -print
    [ $excludeVARLOG -eq 0 ] && find /var/log/* -mmin $duration -print
    [[ -n "$filePath" ]] && find $filePath -mmin $duration -print
    if [[ -n "$fileName" ]]; then
      while read -r line; do
        find $line -mmin $duration -print
      done < $fileName
    fi
  fi
}

:> $outputFile
if [[ -n "$outputFile" ]]; then
  getEditedFiles > $outputFile
else
  getEditedFiles
fi
