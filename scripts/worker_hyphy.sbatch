#!/bin/bash
# Project:EVOTREE
## How to run: sbatch --array=1-340 worker_hyphy.sbatch 
#SBATCH --account=nn8023k
# Wall clock limit:
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
## Recommended safety settings:
set -o errexit # Make bash exit on any error
set -o nounset # Treat unset variables as errors

#Purge and list modules
module purge
module load Anaconda3/2022.10
set +eu
source activate hyphy
set -eu

# It is also recommended to to list loaded modules, for easier debugging:
module list

# Define some stuff
PARENT=/cluster/home/siribi/work/EVOTREE/hyphy/FEBRUARY23_reruns/FABALES_July22/hyphy_rerun_timetree
ERRORFILE=errors.log

# If needed copy up to scratch
#cp -r $SUBMITDIR/dir.$TASK_ID $SCRATCH

##cd to right directory (either scratch or submit directory) 
cd $PARENT
#cd $SCRATCH

#run hyphy:
cd dir.$SLURM_ARRAY_TASK_ID
FALIST=`ls -1 *.fasta`
i=1
for FAFILE in $FALIST
        do
        FILEBASE=$(echo $FAFILE | cut -f1 -d.)
        echo $FILEBASE 
	if hyphy relax --alignment $FILEBASE.guidance.edit.fasta --tree $PARENT/FABALES_timetree_hyphy.nwk --test Foreground --reference Background > $FILEBASE.guidance.edit.hyphy.stdout.txt | grep "Check errors.log for execution error details."; then
	continue
	fi
	if grep ">Evidence for" $FILEBASE.guidance.edit.hyphy.stdout.txt; then
	echo "RELAX found evidence for shift in selection pressure" &
	mv $FILEBASE.guidance.edit.fasta.RELAX.json $PARENT/RELAX_TRUE &
	mv $FILEBASE.guidance.edit.hyphy.stdout.txt $PARENT/RELAX_TRUE
	elif test -f "$ERRORFILE"; then
	echo "Error detected. Moved log to error file directory" &
	mv errors.log $FILEBASE.errors.log &
	mv $FILEBASE.errors.log $PARENT/ERRORS &
	mv $FILEBASE.guidance.edit.hyphy.stdout.txt $PARENT/ERRORS &
	else
	echo "No evidence for shift in selection pressure."
	mv $FILEBASE.guidance.edit.fasta.RELAX.json $PARENT/RELAX_FALSE &
	mv $FILEBASE.guidance.edit.hyphy.stdout.txt $PARENT/RELAX_FALSE
	fi
done
