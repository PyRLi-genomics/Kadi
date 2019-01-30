#!/bin/bash

#SBATCH -n 1

#SBATCH --mail-type=BEGIN, FAIL

#SBATCH --mem=50G

echo 
echo "$SLURM_JOB_ID" >> ${result_dir}/log_files/JobID

#PATH TO THE CONFIG FILE
source $1
#########source $projectDir/log_trace

if [ ! -d "$result_dir"/merged_files ]; then
        mkdir -p "$result_dir"/merged_files
fi

cd "${raw_data_dir}"

sample_list=$(ls)
sample_list_array=( $sample_list )

Sample_ID=${sample_list_array[${SLURM_ARRAY_TASK_ID}]}

#cd "$raw_data_dir"/$Sample_ID

if [ $type == SE ];then
	mkdir "$result_dir"/merged_files/$Sample_ID
	cat `ls *.fastq.gz` >>  "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged.fastq.gz 2>> "$result_dir"/log_files/merged_files.error
	gunzip  "$result_dir"/merged_files/$Sample_ID/"$Sample_ID".fastq.gz  2>> "$result_dir"/log_files/merged_files.error
	echo "$Sample_ID file merging SUCCESSFULL"
elif [ $type == PE ];then
	cat `ls *.R1*.fastq.gz | sort -`  >> "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged_R1.fastq.gz  2>> "$result_dir"/log_files/merged_files.error
	gunzip  "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_R1.fastq.gz  2>> "$result_dir"/log_files/merged_files.error


	cat `ls *.R2*.fastq.gz | sort -`  >> "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged_R2.fastq.gz  2>> "$result_dir"/log_files/merged_files.error

	gunzip  "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_R2.fastq.gz  2>> "$result_dir"/log_files/merged_files.error
	echo "$Sample_ID file merging SUCCESSFULL"

else
	echo " SEQUENCING TYPE SE (single end) or PE (PAired end) INFORMATION NOT PROVIDED "
	exit 1
fi

source "$result_dir"/log_files/log_trace
if [ -s "$result_dir"/log_files/merged_files.error ] && [ "$CMD1_trace" == "OK" ]; then
	sed -i -e 's/CMD1_trace=OK/CMD1_trace=FAIL/g' "$result_dir"/log_files/log_trace
fi 
