#!/bin/bash

ping -c1 github.com >& /dev/null
if [ $? -ne 0 ]; then
   printf "Can't ping github.com: Not connected to the internet? resolv.con error?\n"
   exit 1
fi

upToDate=$(git status | grep -ci "up to date")
if [ $upToDate -eq 1 ]; then
   printf "Already up to date\n"
   exit 0
fi

git pull origin
if [ $? -ne 0 ]; then
   printf "Failed: git pull origin\n"
   exit 1
fi

which mpg123 > /dev/null
if [ $? -ne 0 ]; then
   printf "the mp3 to wav converter (mpg123) is not installed: type 'sudo apt install mpg123'\n"
   exit 1
fi

# for f in *.mp3; do mpg123 -vm2 -w "/home/pi/boomer/audio/${f%.mp3}.WAV" "$f"; done
for f in *.mp3 ; do 
   mpg123 -vm2 -w "/home/pi/boomer/audio/${f%.mp3}.WAV" "$f" >& /dev/null
   if [ $? -ne 0 ]; then
      printf "Failed: mpg123 $f - exiting mp3 to wav conversion loop\n"
      exit 1
   fi
done
exit 0