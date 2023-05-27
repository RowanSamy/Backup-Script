#!/bin/bash
flag=1  #to detect any error in input
count=$(ls $2 | wc -l)  #counting no. of files in backupdir for backups

if [ $# -ne 4 ]
then
   echo "You need to enter 4 arguments with this order:"
   echo "1-Source directory        2-destination directory 
3-waiting time bet checks 4-max backups reserved"
   flag=0
fi
if [ ! -d "$1" ]
  then
   echo "                                   "
   echo "Please enter an existing source directory"
   flag=0 
fi   
if [[ $(($3)) != $3 ]]
then
     echo "                                   "
     echo $3 ": Third argument must be an integer"
     flag=0 
fi     
if [[ $(($4)) != $4 ]]
then
     echo "                                   "
     echo $4 ": Fourth argument must be an integer"
     flag=0
fi

function cpy {    #Function that copies source to the destination
mkdir "$2/$(date +"%Y-%m-%d-%I-%M-%S")"
des=$(pwd)
#echo "filepath is" $des
cp -R $1 $2/$(date +"%Y-%m-%d-%I-%M-%S");
count=`expr $count + 1`
}

if [ $flag -eq 1 ]
then
while [ $count -gt $4 ]  #if already exists files in backupdir
do
      sleep 2
      rm -r $2/$(ls -r $2 | tail -1)   #removing the first element
      count=`expr $count - 1`
done
ls -lR $1 > directory-info.last
cpy $1 $2   #source  destination
while true    # To check if modification occurs
  do
   if [ $count -gt $4 ]
   then
      rm -r $2/$(ls -r $2 | tail -1)   #removing the oldest element
      count=`expr $count - 1`
   fi
   sleep $3
   ls -lR $1 > directory-info.new
   cmp -s directory-info.last directory-info.new
   x=$?
   if [ $x -eq 1 ]
      then
      cpy $1 $2
      cp directory-info.new directory-info.last
   fi  
  done
else 
  exit 0;
fi
