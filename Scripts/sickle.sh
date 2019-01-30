#!/bin/bash

#SBATCH -n 1

#SBATCH -c 4

#SBATCH --mail-type=BEGIN, FAIL

#SBATCH --mem=50G
module load sickle

echo $SLURM_JOB_ID >> "$result_dir"/log_files/JobID

source $1
#########source $projectDir/log_trace

if [ ! -d "$result_dir"/"$CMD3" ]; then
        mkdir "$result_dir"/"$CMD3"
fi

cd "$result_dir"/merged_files/
sample_list=$(ls)
sample_list_array=( $sample_list )

Sample_ID=${sample_list_array[${SLURM_ARRAY_TASK_ID}]}

if [ $type == SE ];
then
	sickle se -n \
		-f  "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged.fastq \
		-t sanger \
		-o "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged_sickle.fastq \
		-l 45 \
		-q 28 \
		2>> "$result_dir"/log_files/"$CMD3".error 

elif [ $type == PE ];then
	sickle pe -n \
		-f  "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged_R1.fastq \
		-r  "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged_R2.fastq \
		-o  "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged_sickle_R1.fastq \
		-p  "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged_sickle_R2.fastq \
		-t sanger \
		-l 45 \
		-q 28 \
		-s "$result_dir"/merged_files/$Sample_ID/"$Sample_ID"_merged_sickle_single.fastq \
		2>> "$result_dir"/log_files/"$CMD3".error 
		
else
	echo " SEQUENCING TYPE SE (single end) or PE (PAired end) INFORMATION NOT PROVIDED "
	exit 1
fi

source "$result_dir"/log_files/log_trace
if [ -s "$result_dir"/log_files/"$CMD3".error ] && [ "$CMD2_trace" == "OK" ] && [ "$CMD3" == "sickle" ] ; then
	echo " ${CMD2} worked fine"
else

	sed -i -e 's/CMD3_trace=OK/CMD3_trace=FAIL/g' "$result_dir"/log_files/log_trace
fi 



