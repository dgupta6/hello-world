#!/bin/bash
#This script identifies failed gams jobs and re-runs them
#Author: Dhruv Gupta, Feb 17, 2016

#First find gdx files of zeros size
find -size 0 -name "*.gdx" > IncompleteRuns.sh
cp IncompleteRuns.sh IncompleteRuns.log

#Remove ./ from the above list and substitute gdx with gms
sed -i 's/.\//gams /' IncompleteRuns.sh
sed -i 's/.gdx/.gms/' IncompleteRuns.sh

#Now remove ./ and .gdx from IncompleteRuns.log file
sed -i 's/.\///' IncompleteRuns.log
sed -i 's/.gdx//' IncompleteRuns.log

rm condor_job_list_raw
touch condor_job_list_raw

#For every line in IncompleteRuns.log file:
#match the string to JobIDs.log file
#to look up job number

while read job_name; do 
#	echo $job_name
	grep $job_name JobIDs.log >> condor_job_list_raw	
done < IncompleteRuns.log

#From list of job numbers, create a list which 
#can be used for resubmission by condor to cluster
awk '{print "condor_submit gams"$2".cmd"}' condor_job_list_raw > re_condor_job_list.bat
chmod +x re_condor_job_list.bat

#cat IncompleteRuns.sh
if test -s IncompleteRuns.sh;
then
         chmod +x IncompleteRuns.sh
	 n_runs=`wc -l < IncompleteRuns.sh`
	 
	if test "$n_runs" -lt "10";
	   then
		cat IncompleteRuns.log
	fi;
	 
         echo "$n_runs runs not successful"
	 echo "list: see list, y: resubmit to cluster, yy:run sequentially, n: don't do anything"
	 echo "re-run unsuccessful jobs? (list,y,yy or n)"
         read -e answer
         if test "$answer" == "yy";
            then
                 ./IncompleteRuns.sh
         elif test "$answer" == "n";
            then
                echo "you chose not to re-run failed jobs";
         elif test "$answer" == "y";
            then
                 ./re_condor_job_list.bat
         elif test "$answer" == "list";
            then
                 cat IncompleteRuns.log 
         else
                echo "Give only y,yy or n"
         fi;
else
         echo "All runs successful"
fi;



#if test -s IncompleteRuns.sh; then echo "Yes" ;else echo "No"; fi;
