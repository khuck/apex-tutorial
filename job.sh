#!/bin/bash -l
#SBATCH --time=00:10:00
#SBATCH --account=project_2006549
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH -p
#SBATCH gputest
#SBATCH --gres=gpu:a100:1
#SBATCH --hint=multithread

# set the number of threads based on --cpus-per-task
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
# Bind OpenMP threads to hardware threads
export OMP_PLACES=cores

module load cuda/11.5.0 cmake papi APEX

#srun ./build/bin/std_thread_cpp
srun apex_exec --apex:pthread --apex:csv --apex:tasktree ./build/bin/std_thread_cpp

