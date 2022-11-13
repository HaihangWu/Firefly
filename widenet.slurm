#!/bin/bash
# The project ID which this job should run under:
#SBATCH --account="punim0512"

# The name of the job:
#SBATCH --job-name="example.py"

# Partition for the job:
#SBATCH -p gpu-a100

# --partition deeplearn
# --qos gpgpudeeplearn

# Request different amount of resources for different nodes
# --constraint=[dlg1|dlg2|dlg3|dlg4]
# --constraint=dlg4
#SBATCH --nodes=1                # node count
#SBATCH --ntasks-per-node=1      # total number of tasks per node
#SBATCH --gres=gpu:1             # number of gpus per node
#SBATCH --cpus-per-task=8        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=8G

# Maximum number of tasks/CPU cores used by the job:
# --ntasks=4
# --gpus-per-task=1  # number of gpus per task

# The maximum running time of the job in days-hours:mins:sec
#SBATCH --time=01-12:00:0

# Send yourself an email when the job:
#SBATCH --mail-user=robotic.engineer.dylan.wu@gmail.com
#SBATCH --mail-type=BEGIN,FAIL,END

source /usr/local/module/spartan_new.sh
module load fosscuda/2020b
module load gcc/10.2.0 cuda/11.1.1 openmpi/4.0.5
module load python/3.8.6
module load pytorch/1.9.0-python-3.8.6
module load torchvision/0.10.0-python-3.8.6-pytorch-1.9.0
module load matplotlib/3.3.3-python-3.8.6

# The job command(s):
export MASTER_PORT=$(expr 10000 + $(echo -n $SLURM_JOBID | tail -c 4))
export WORLD_SIZE=$(($SLURM_NNODES * $SLURM_NTASKS_PER_NODE))
echo "WORLD_SIZE="$WORLD_SIZE

master_addr=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_ADDR=$master_addr
echo "MASTER_ADDR="$MASTER_ADDR
echo "r$SLURM_NODEID Launching python script"

srun python main.py --method fireflyn --model vgg19 >> bdNMmaxfirstgrd-28-10.txt