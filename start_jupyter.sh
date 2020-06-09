#!/usr/bin/env bash
echo LSF job started...

# load jupyterhub conda env that has jupyterhub installed
echo activating jupyterhub conda environment...
export CONDA_ENVS_DIRS=/software/hgi/installs/anaconda3/envs
export CONDA_PKGS_DIRS=/software/hgi/installs/anaconda3/pkgs
eval "$(conda shell.bash hook)"
conda activate nextflow20 #/lustre/scratch118/humgen/resources/conda_envs/jupyterhub

# get free port for jupyterhub
echo get free port on host...
read LOWERPORT UPPERPORT < /proc/sys/net/ipv4/ip_local_port_range
while :
do
        PORT="`shuf -i $LOWERPORT-$UPPERPORT -n 1`"
        ss -lpn | grep -q ":$PORT " || break
done
echo free port selected is $PORT

echo get host IP address...
HOST_IP=$(hostname -i)
echo host IP is $HOST_IP

export JUPYTER_PATH=$PWD
export JUPYTER_CONFIG_DIR=$PWD
echo jupyter config paths are:
jupyter --paths
echo starting jupyter lab server...
jupyter lab --port=$PORT --ip=0.0.0.0 >> jupyter_lab.log 2>&1

HOST_NAME=$(hostname)
echo Tunnelling SSH command: ssh -L $PORT:$HOST_NAME.internal.sanger.ac.uk:$PORT ${USER}@ssh.sanger.ac.uk  >> jupyter_lab.log 
