#!/bin/bash


#This module is loaded to create sections in log file.

module load figlet

if [ ! -d "$result_dir"/log_files ]; then
        mkdir -p "$result_dir"/log_files
fi

if [ ! -f "$result_dir"/log_files/log_trace ]; then
        touch "$result_dir"/log_files/log_trace
fi

if [ ! -f "$result_dir"/log_files/JobID ]; then
        touch "$result_dir"/log_files/JobID
	touch "$result_dir"/log_files/Slurm_STDOUT
fi

#SLURM LOG OUT
OUT=${result_dir}/log_files/Slurm_STDOUT


#PATH TO THE CONFIG FILE
config_path="$1"

# SOURCING THE CONFIG FILE
source ${config_path}

#SOURCING THE VARIABLES FROM THE LOG TRACE FILE TO FIND FAILED JOBS
#IF THE RUN IS FIRST TIME IT WILL BE EMPTY
source ${result_dir}/log_files/log_trace


#DIFFERENT COMMANDS THAT WILL BE EXECUTED
commands="CMD1 CMD2 CMD3 CMD4 CMD5 CMD6 CMD7"

##...RUNNING CMD1....###

# $OUT IS FILE CONTAINING STDOUT OF THE PROCESS 

figlet merge files >> ${OUT}

#CHECK IF THE USER WANT TO PASS CMD1 OR CMD1 WAS SUCCESSFUL (OK) IN PREVIOUS RUN

if [ "${CMD1}" -eq "PASS" ] || [ "${CMD1_trace}" -eq "OK" ];then

	echo  "Merging option was PASSED  or merging was successfully executed in previous run " >> ${OUT}
else
	#CD TO RAW DATA DIRECTORY
	cd  $raw_data_dir
	# COUNTS THE NUMBER OF SAMPLES
	total_samples=`ls | wc -w`
	# INITIAL "CMD1_trace" VALUE SET TO "OK"
	echo "CMD1_trace=OK" >> ${result_dir}/log_files/log_trace
#	cd ${KadiRun}
	sbatch --mail-user="$emailID" --output=${OUT} --job-name=merge_"RunID" --array=1-$total_samples%$total_samples  ${KadiRun}/Scripts/"$CMD1".sh $config_path

fi	





sleep 60
# $OUT IS FILE CONTAINING STDOUT OF THE PROCESS 
figlet fastqc RAW reads >> $OUT

#CHECK IF THE USER WANT TO PASS CMD1 OR CMD1 WAS SUCCESSFUL (OK) IN PREVIOUS RUN
if [ "$CMD2" -eq "PASS" ] || [ "$CMD2_trace" -eq "OK" ];then

	echo  "FASTQC of raw read option was PASSED  or  was successfully executed in previous run "  >> ${OUT}
else
	#CD TO MERGED FILES DIRECTORY
	cd  $"$result_dir"/merged_files/
	#COUNTING NUMBER OF SAMPLES BASED ON THE LIST OF DIRECTORIES
	total_samples=`ls | wc -w`
	# INITIAL "CMD1_trace" VALUE SET TO "OK"
	echo "CMD2_trace=OK" >> "$result_dir"/log_files/log_trace
#	> "$result_dir"/log_files/fastqcRAW.error
#	cd "$KadiRun"
	#FROM THE FILE JOBID PICKS UP THE LAST RUNNING JOBID TO CHECK IF THAT IS COMPLETED 
	jobhold=`tail -1 "$result_dir"/log_files/JobID`
	sbatch -d afterok:"$jobhold" --mail-user="$emailID" --output="$OUT" --job-name=fastqc_"RunID" --array=1-$total_samples%$total_samples ${KadiRun}/"$CMD2".sh $config_path
fi	

sleep 60







figlet "$CMD3" >> $OUT

if [ "$CMD3" -eq "PASS" ] || [ "$CMD3_trace" -eq "OK" ];then

	echo  ""$CMD3" of raw read option was PASSED  or  was successfully executed in previous run " >> ${OUT}

else
	cd  $"$result_dir"/merged_files/
	total_samples=`ls | wc -w`
	echo "CMD3_trace=OK" >> "$result_dir"/log_files/log_trace
#	> "$result_dir"/log_files/"$CMD3".error
	cd "$KadiRun"
	jobhold=`tail -1 "$result_dir"/log_files/JobID`
	sbatch -d afterok:"$jobhold" --mail-user="$emailID" --output="$OUT" --job-name=fastqc_"RunID" --array=1-$total_samples%$total_samples "$CMD3".sh $config_path
fi

sleep 60







figlet "$CMD4" >> $OUT

if [ "$CMD4" -eq "PASS" ] || [ "$CMD4_trace" -eq "OK" ];then

	echo  ""$CMD4" of raw read option was PASSED  or  was successfully executed in previous run " >> ${OUT}

else
	cd  $"$result_dir"/merged_files/
	total_samples=`ls | wc -w`
	echo "CMD4_trace=OK" >> "$result_dir"/log_files/log_trace
	> "$result_dir"/log_files/"$CMD4".error
	cd "$KadiRun"
	jobhold=`tail -1 "$result_dir"/log_files/JobID`
	sbatch -d afterok:"$jobhold" --mail-user="$emailID" --output="$OUT" --job-name=fastqc_"RunID" --array=1-$total_samples%$total_samples "$CMD4".sh $config_path
fi	

