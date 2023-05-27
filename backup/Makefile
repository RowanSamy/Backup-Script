.ONESHELL:  #deals normally with if

.PHONY: backupdscript 

#source=/home/rowan/lab2/dir
#backupdir=/home/rowan/lab2/backupdir
#wait= 7
#maxbackups=2

backupdscript:
	@ if [ ! -d $(backupdir) ] ;  then  
	@mkdir $(backupdir)
	@ fi
	@./backupd.sh $(source) $(backupdir) $(wait) $(maxbackups)
	
	
	
	

	

