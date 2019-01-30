#!/bin/bash

#SBATCH -n 1

#SBATCH -c 4

#SBATCH --mail-type=BEGIN, FAIL

#SBATCH --mem=50G


module load fastqc
module load java


echo $SLURM_JOB_ID >> "$result_dir"/log_files/JobID

source $1
#########source $projectDir/log_trace

if [ ! -d "$result_dir"/fastqc_raw ]; then
        mkdir "$result_dir"/fastqc_raw
fi

cd "$result_dir"/merged_files/
sample_list=$(ls)
sample_list_array=( $sample_list )

Sample_ID=${sample_list_array[${SLURM_ARRAY_TASK_ID}]}

cd "$result_dir"/merged_files/$Sample_ID

fastqc -q -t 4 -o "$result_dir"/fastqc_raw/ *.fastq 2>>"$result_dir"/log_files/fastqcRAW.error


source "$result_dir"/log_files/log_trace
if [ -s "$result_dir"/log_files/fastqcRAW.error ] && [ "$CMD1_trace" == "OK" ]; then
	sed -i -e 's/CMD2_trace=OK/CMD2_trace=FAIL/g' "$result_dir"/log_files/log_trace
fi 
