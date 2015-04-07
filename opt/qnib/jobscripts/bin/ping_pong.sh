#!/bin/bash
#SBATCH --job-name=PingPong
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --ntasks-per-node=1

mkdir -p ${HOME}/slurm/${SLURM_JOBID}/
cd ${HOME}/slurm/${SLURM_JOBID}/
DOMAIN=node.consul
BW_LIMIT=3000
for node in $(echo ${SLURM_NODELIST}|sed -e 's/,/ /g');do
    if [ ${node} != ${SLURMD_NODENAME} ];then
        logger --tag slurm_${SLURM_JOBID} "fallocate -l 60M /tmp/test.dd"
        srun --exclusive -n1 fallocate -l 60M /tmp/test.dd
        sleep 15
        logger --tag slurm_${SLURM_JOBID} "mkdir -p ${HOME}/slurm/${SLURM_JOBID}/"
        mkdir -p ${HOME}/slurm/${SLURM_JOBID}/
        sleep 15
        logger --tag slurm_${SLURM_JOBID} "rsync --bwlimit=${BW_LIMIT} -aP /tmp/test.dd ${node}.${DOMAIN}:${HOME}/slurm/${SLURM_JOBID}/"
        srun --exclusive -n1 rsync --bwlimit=${BW_LIMIT} -aP /tmp/test.dd ${node}.${DOMAIN}:${HOME}/slurm/${SLURM_JOBID}/
        logger --tag slurm_${SLURM_JOBID} "Delete local file and file within ${HOME}/slurm/${SLURM_JOBID}/"
        srun --exclusive -n1 rm -f ${HOME}/slurm/${SLURM_JOBID}/test.dd /tmp/test.dd
        sleep 15
    fi
done
