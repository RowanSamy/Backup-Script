
#  -------------------------------------   **Writing a shell script to backup a directory** ------------------------------------------
##  **Description**    
   ### ***1- Overview on programs' hierarchy***   
  
• This project is a simple backup system where it backs-up a source directory into a destination directory specified by the user.
 • First of all, my program consists of 2 main files:  

    1- A bash script called "backupd.sh" --> this is where my code is written using certian lunix commands.         
    2- A Makefile called "makefile" --> this is where my bashscript is called and parameters are passed to the bash script.      
•In addition to these 2 files there is a directory called **dir** which is the **source** directory and another one called **backupdir** which is the **destination** directory.  
•On running my program there are 2 text files created:

         1- directory-info.last--> holds the current contents of the source directory before backing it up into the destination directory.  
         2- directory-info.new --> holds the contents of the source directory after the processor sleeps for a specified time.
    These directories helps me to know whether a modification happens or not therefore you will know whether a backup is needed or not.   
### ***2-Code Explanation***
 • Before running the user has to enter 4 arguments with this **same exact order** :  

    1-source directory 2-destination directory 3-waiting time between each backup  4-max number of backups.  

 • So on running the Make file ,the compiler validates the 4 arguments entered and checks that:

    1-There are exactly 4 arguments not less not more.If detected otherwise an error message appears telling him to enter them properly.  
    2-Source destination must exist by searching in all directories on my system using "if [ ! -d "$1 ]" .
    3-Checks for the destination directory if it doesn't exist it creates a new one.
    4-Waiting time between each backup and max number of back ups must be an integer by comparing each with its self. ex: "[ $(($4)) != $4 ]".  
 • If any error was detected a flag will indicate an error and the program will terminate. 

 •Otherwise, program will start execution: 

    1-At first a variable count is intiallized where it counts the number of files in the destination directory using  ***count=$(ls $2 | wc -l)*** where:  
          ls    : lists the files in the given directory.  
          |     : pipe passses the output of the first half as an input to the second half. 
          wc -l : counts the number of lines passed by the pipe from the first half.

    2-A while loop checks whether the no. in ***count*** exceeds the ***max no. of backups*** if yes--> it will start to remove directories till reaches max no of backups.

    3-It stores all directories and subdirectories of the source in "directory-info.last". 

    4-Then calls the "cpy" function that copies the source and places it in a new directory in the destination named after the current date having the formate  YYYY-MM-DD-hh-mm-ss.

    5-Inside a while loop, it sleeps for number of seconds equal to the waiting time entered by user then stores stores all directories and subdirectories of the source in "directory-info.new". 

    6-Then compares both text files together if $? != 1 this means that a modification happened to the source file. 

    7-So it copies the source to the destination again.

    8-It keeps looping till reaching the max no. of backups entered by the user so it will remove the oldest directory and replaces it with the new one so that no of directories in destinations never exceeds max no. of back-ups.

    9-To remove the oldest directory: 
        • (ls -r $2 | tail -1): it lists the directories in destination reversly and "tail -1" gets the last one on the list. 
        • rm -r $2/$(ls -r $2 | tail -1): the returned value will be removed recursivly which is the oldest one. 
         
    10-This loop never terminates unless the user writes ctrl+C in the terminal.    

### ***3-Bonus Explanation---Cron Job*** 
• A new bash script is created and named **backup-cron.sh** .  
• A cron file is a file that loops its self every specified time unlike part 1 so we removed the waiting time between each check.  
• On running **backup-cron.sh**,the compiler validates the 3 arguments entered and checks that:

    1-There are exactly 3 arguments not less not more.If detected otherwise an error message appears telling him to enter them properly.  
    2-Source destination must exist by searching in all directories on my system using "if [ ! -d "$1 ]" .
    3-Checks for the destination directory if it doesn't exist it creates a new one.
    4-Max number of back ups must be an integer by comparing each with its self. ex: "[ $(($4)) != $4 ]".
• If any error was detected, the program will terminate.   
• When the program starts execution: 

    1-It stores all directories and subdirectories of the source in "directory-info.new".

    2-Then checks if "directory-info.last" exists if it doesn't exist this means that its the first time to run the program so it creates it and copies the destination into the source.

    3-If "directory-info.last" exists it compares it with "directory-info.new" to see whether a modification occured or not. 

    4-If a modification happened it counts the directories in the destination and compares with the max no of backups:
        • if the count exceeded the no of max backups--> it removes the oldest directory and puts the new one.
        • if not it copies the source directory into the destination directly.
         
    5-If a modification doesn't exist -->nothing happens.
    
    6-Theese five steps are on repeat as long as the cron is working.  
    
### ***To run the backup every 3rd Friday of the month at 12:31 am*** 
"31 00 15-21 * 5 (cd <pathOfcronFile> && ./backup-cron.sh dir backupdir 2)" will be written in terminal where: 

    • 31   : stands for minutes.  
    • 00   : stands for 12 am.  
    • 15-21: range of the third friday in the month.
    • *    : stands for all months of the year.  
    •5     : friday is the fifth day in the week. 
    
    

    
 

## **Installation**   
• You need to install Oracle VM virtual box then install ubuntu.
### ***1- Program Installation***    
 • Before wriring in the terminal **make** command to execute the makefile you have to check on the following first.     
 **Step 1**
 -------     
 You will update your Operating system using this command "sudo apt update".      
 **Step 2**    
 Check if make is already installed or not by typing "make" in the terminal if an error occured.Therefore you have to install the make pachage.     
 **Step 3**     
 To instal make pachage type "make apt install make".   
 **Step 4**      
 After installing we will check the make directory on our system in order to use the make package using this command "ls /usr/bin/make".    
 **Step 5**
 You can now use make command safely.   
 
 ### ***2-Bonus Installation*** 
 •To install **crontab** on your terminal,you have to follow theese steps:  
 **Step 1**
 -------     
 Open your terminal and write "**crontab -e**" command.
 **Step 2**    
 A list appears in terminal and asks you to choose --> choose number"**1**" which is **/bin/nano** .
 **Step 3**     
 Enter the command in this formate **"* * * * * (cd <pathOfcronFile> && ./backup-cron.sh dir backupdir 2)"* 
 **Step 4**      
 Press **ctrl + o** then **enter** then **ctrl + x** 
 **Step 5**
 **crontab :istalling new crontab** appears which means that the cron is now activated.  
 


 
## **How to run**  
### ***1- Running the Makefile***  
• To run the program you have to make this steps in this order.    
 |Steps  
 ------ 
1- Open the terminal.     
2- Go to the directory 6733-lab2 using command "**cd /path-of-file**" seperated by **/** .    
3- Change the mode of the bash file to be executable using this command: "**chmod +x ./backupd.sh**".    
4- Make sure you installed **make** command as in previous section.
5-Type "**make dir=nameOfsource backupdir=nameOfbackup wait=waitingTime maxbackups=maxNobackups**".    

•The program starts running and backup begins.    
•For any inquiries you can check the Support section.  
### ***Running the Cronfile*** 
|Steps  
 ------ 
1- Change the mode of the bash file to be executable using this command: "**chmod +x ./backup-cron.sh**".    
2-Make sure you finished the installation steps first which means that cron file is activated.

 3-If you want to change any inputs:  

    1-Open your terminal and write "**crontab -e**" command.
    2-You will find this previously written command **"* * * * * (cd <pathOfcronFile> && ./backup-cron.sh dir backupdir 2)"* --> you can alter whatever you want.  
    3-Press **ctrl + o** then **enter** then **ctrl + x** 
    4-**crontab :istalling new crontab** appears which means that the cron accepted the alternation and is activated agian.  
## **Support**    
•If you require any additional information or inquiries, please don’t hesitate to contact me at any time.    
•You can send an e-mail via : rowansamy2@gmail.com. 