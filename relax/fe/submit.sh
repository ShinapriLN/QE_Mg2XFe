#!/bin/bash
#SBATCH -p compute                        # select the partition
#SBATCH --nodes=1                         # define number of node
#SBATCH --ntasks-per-node=64              # define number of tasks per node
#SBATCH --cpus-per-task=1                 # OMP threads
#SBATCH -t 3:00:00                        # define reserve time
#SBATCH -J mg2feh6-convtest-kp            # define the job name
#SBATCH -A lt200309                       # define your project account

module purge
module load QuantumESPRESSO/7.2-libxc-6.1.0-cpu

mkdir -p $HOME/tmp_qe/$SLURM_JOB_ID
export ESPRESSO_TMPDIR=$HOME/tmp_qe/$SLURM_JOB_ID
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
#export ESPRESSO_PSEUDO=/home/clawicha/Components/SSSP_1.3.0_PBEsol_precision
ulimit -s unlimited

[ -d "$ESPRESSO_TMPDIR" ] || mkdir -p "$ESPRESSO_TMPDIR"

# Check if there are any arguments
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 arg1 arg2 ..."
    exit 1
fi

for arg in "$@"; do
QE_INPUT_FILE="$arg"
OUTPUT_FILE_PW="${QE_INPUT_FILE%.in}.out"

srun --cpus-per-task=${SLURM_CPUS_PER_TASK} pw.x -inp ${QE_INPUT_FILE} > ${OUTPUT_FILE_PW}
done
