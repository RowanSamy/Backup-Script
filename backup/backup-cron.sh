if [ $# -ne 3 ]
then
   echo "You need to enter 3 arguments with this order:"
   echo "1-Source directory        2-destination directory 
3-max backups reserved"
   exit 0;
fi
if [ ! -d "$1" ]
  then
   echo "                                   "
   echo "Please enter an existing source directory"
   exit 0;
fi  
if [ ! -d $2 ] ;  then  
	mkdir $2
fi 
if [[ $(($3)) != $3 ]]
then
     echo "                                   "
     echo $3 ": Third argument must be an integer"
     exit 0;
fi
 
 ls -lR $1 > directory-info.new
 if [ ! -f "directory-info.last" ]
 then
 count=$(ls $2 | wc -l)  #counting no. of files in backupdir for backups
  mkdir "$2/$(date +"%Y-%m-%d-%I-%M-%S")"
  cp -R $1 $2/$(date +"%Y-%m-%d-%I-%M-%S");
  ls -lR $1 > directory-info.last
 fi
 cmp -s directory-info.last directory-info.new
 x=$?
 if [ $x -eq 1 ]
 then
 count=$(ls $2 | wc -l)  #counting no. of files in backupdir for backups
 if [ $count -eq $3 ]
 then
   rm -r $2/$(ls -r $2 | tail -1)   #removing the oldest element
 fi
 mkdir "$2/$(date +"%Y-%m-%d-%I-%M-%S")"
 cp -R $1 $2/$(date +"%Y-%m-%d-%I-%M-%S");
 ls -lR $1 > directory-info.last
 fi  
