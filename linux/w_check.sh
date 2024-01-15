#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) #https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
echo "MAKE SURE TO HAVE THE w_check.cron IN THE SAME FOLDER AS ME!"
crontab $SCRIPT_DIR/w_check.cron
crontab -l