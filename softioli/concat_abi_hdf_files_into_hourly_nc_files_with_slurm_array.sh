#!/bin/bash

#SBATCH --job-name=concat_abi_hourly
#SBATCH --ntasks=1
#SBATCH -o /home/patj/logs/concat-sat-data/ABI/concat_arr_job-%N-%j_%A-%a.out

#####################################################################################################
# Script to concat 15-min ABI HDF4 files into hourly pre-regrid netCDF files with a slurm array
#
# usage: sbatch --array=xx-xx%xxx $0 FILE_WITH_DIR_PATHS [EXTRA_PYTHON_ARGUMENTS]
#   required arguments:
#	FILE_WITH_DIR_PATHS: txt file with list of paths pointing to daily directories that need to be concatenated
#   optional arguments:
#	EXTRA_PYTHON_ARGUMENTS: optional, extra arguments to be passed to the python concat script (for example --overwrite --rm-temp-files)
#####################################################################################################

if [ $# -lt 1 ]; then
        echo "Usage: sbatch --array=xx-xx%xxx $0 FILE_WITH_DIR_PATHS [EXTRA_PYTHON_CONCAT_ARGS]"
        exit 1
fi

# maps each line of file to an array element
mapfile -t ARGS_LIST < "$1"
# select arg corresponding to current array task (for job number 5, select args element at index 5)
ARGS=${ARGS_LIST[${SLURM_ARRAY_TASK_ID}]}

# shift so that remaining args (optional extra python args) can be accessible with $@
shift 1
EXTRA_PYTHON_ARGS=$@

if [ ! -d "$ARGS" ]; then
	echo "<!> ERROR: '$ARGS' is not a directory, please check the paths and try again"
	exit 1
fi

date
echo "--- START concat ---"
echo "Directory to concat: $ARGS"
echo "Running: /home/patj/miniconda3/envs/softioli-src/bin/python /home/patj/SOFT-IO-LI/src/softioli/concat_abi_hdf_files_into_hourly_nc_files_script.py --dir-path $ARGS $EXTRA_PYTHON_ARGS --print-debug"

/home/patj/miniconda3/envs/softioli-src/bin/python -u /home/patj/SOFT-IO-LI/src/softioli/concat_abi_hdf_files_into_hourly_nc_files_script.py --dir-path $ARGS $EXTRA_PYTHON_ARGS --print-debug

echo "----------------------"
date

