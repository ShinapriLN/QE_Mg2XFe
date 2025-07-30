#!/bin/bash
#SBATCH -p compute-limited                        # select the partition
#SBATCH --nodes=1                         # define number of node
#SBATCH --ntasks-per-node=16              # define number of tasks per node
#SBATCH --cpus-per-task=4                 # OMP threads
#SBATCH -t 24:00:00                        # define reserve time
#SBATCH -J mg2feh6-sumpdos            # define the job name
#SBATCH -A lt200309                       # define your project account

module purge
module load QuantumESPRESSO/7.2-libxc-6.1.0-cpu

mkdir -p $HOME/tmp_qe/$SLURM_JOB_ID
export ESPRESSO_TMPDIR=$HOME/tmp_qe/$SLURM_JOB_ID
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
#export ESPRESSO_PSEUDO=/home/clawicha/Components/SSSP_1.3.0_PBEsol_precision
ulimit -s unlimited

[ -d "$ESPRESSO_TMPDIR" ] || mkdir -p "$ESPRESSO_TMPDIR"

ELEMENTS=()
ORBITALS=()

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --el)
            shift
            while [[ "$#" -gt 0 && ! "$1" =~ ^-- ]]; do
                ELEMENTS+=("$1")
                shift
            done
            ;;
	--orb)
            shift
            while [[ "$#" -gt 0 && ! "$1" =~ ^-- ]]; do
                ORBITALS+=("$1")
                shift
            done
            ;;
        --debug) DEBUG=true; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
done

for el in "${ELEMENTS[@]}"; do
	for orb in "${ORBITALS[@]}"; do
		found_file=0
		files=()
		for file in *\($el\)*\($orb\); do
			if [[ -f "$file" ]]; then
				files+=("$file")
				((found_file++))
			fi
		done
		if [[ $found_file -gt 0 ]]; then
			echo "Found $found_file files matching ($el)($orb): ${files[@]}"
			srun --cpus-per-task=${SLURM_CPUS_PER_TASK} sumpdos.x "${files[@]}" > pdos_fe_${el}_${orb}.dat
		fi
	done
done
