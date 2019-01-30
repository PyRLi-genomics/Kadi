#!/bin/bash


#This module is loaded to create sections in log file.

module load figlet

if [ ! -d "$result_dir"/log_files ]; then
        mkdir "$result_dir"/log_files
fi

if [ ! -f "$result_dir"/log_files/log_trace ]; then
        touch "$result_dir"/log_files/log_trace
fi

if [ ! -f "$result_dir"/log_files/JobID ]; then
        touch "$result_dir"/log_files/JobID
fi


config_path="$1"
source $config_path
source "$result_dir"/log_files/log_trace

commands="CMD1 CMD2 CMD3 CMD4 CMD5 CMD6 CMD7"

##...RUNNING CMD1....###

figlet merge files >> $OUT

if [ "$CMD1" -eq "PASS" ] || [ "$CMD1_trace" -eq "OK" ];then

	echo  "Merging option was PASSED  or merging was successfully executed in previous run "
else
	cd  $raw_data_dir
	total_samples=`ls | wc -w`
	echo "CMD1_trace=OK" >> "$result_dir"/log_files/log_trace
	> "$result_dir"/log_files/merged_files.error
	cd "$KadiRun"
	sbatch --mail-user="$emailID" --output="$OUT" --job-name=merge_"RunID" --array=1-$total_samples%$total_samples ./Scripts/"$CMD1".sh $config_path

fi	

sleep 60

figlet fastqc RAW reads >> $OUT

if [ "$CMD2" -eq "PASS" ] || [ "$CMD2_trace" -eq "OK" ];then

	echo  "FASTQC of raw read option was PASSED  or  was successfully executed in previous run "
else
	cd  $"$result_dir"/merged_files/
	total_samples=`ls | wc -w`
	echo "CMD2_trace=OK" >> "$result_dir"/log_files/log_trace
	> "$result_dir"/log_files/fastqcRAW.error
	cd "$KadiRun"
	jobhold=`tail -1 "$result_dir"/log_files/JobID`
	sbatch -d afterok:"$jobhold" --mail-user="$emailID" --output="$OUT" --job-name=fastqc_"RunID" --array=1-$total_samples%$total_samples "$CMD2".sh $config_path
fi	

sleep 60

figlet "$CMD3" >> $OUT

if [ "$CMD3" -eq "PASS" ] || [ "$CMD3_trace" -eq "OK" ];then

	echo  ""$CMD3" of raw read option was PASSED  or  was successfully executed in previous run "
else
	cd  $"$result_dir"/merged_files/
	total_samples=`ls | wc -w`
	echo "CMD3_trace=OK" >> "$result_dir"/log_files/log_trace
	> "$result_dir"/log_files/"$CMD3".error
	cd "$KadiRun"
	jobhold=`tail -1 "$result_dir"/log_files/JobID`
	sbatch -d afterok:"$jobhold" --mail-user="$emailID" --output="$OUT" --job-name=fastqc_"RunID" --array=1-$total_samples%$total_samples "$CMD3".sh $config_path
fi

sleep 60

figlet "$CMD4" >> $OUT

if [ "$CMD4" -eq "PASS" ] || [ "$CMD4_trace" -eq "OK" ];then

	echo  ""$CMD4" of raw read option was PASSED  or  was successfully executed in previous run "
else
	cd  $"$result_dir"/merged_files/
	total_samples=`ls | wc -w`
	echo "CMD4_trace=OK" >> "$result_dir"/log_files/log_trace
	> "$result_dir"/log_files/"$CMD4".error
	cd "$KadiRun"
	jobhold=`tail -1 "$result_dir"/log_files/JobID`
	sbatch -d afterok:"$jobhold" --mail-user="$emailID" --output="$OUT" --job-name=fastqc_"RunID" --array=1-$total_samples%$total_samples "$CMD4".sh $config_path
fi	
