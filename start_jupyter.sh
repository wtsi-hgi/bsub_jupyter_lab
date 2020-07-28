#!/usr/bin/env bash

# defaults
notebookdir=$PWD
condaenv=/software/hgi/installs/anaconda3/envs/nextflow20

while getopts 'd:e:' OPTION; do
  case "$OPTION" in
    d)
      notebookdir="$OPTARG"
      echo "notebook dir will be $notebookdir"
      ;; 
    e)
      condaenv="$OPTARG"
      echo "jupyter lab conda env is $condaenv"
      ;; 
  esac
done
shift "$(($OPTIND -1))"

echo LSF job started...

# load jupyterhub conda env that has jupyterhub installed
echo activating jupyterhub conda environment...
eval "$(conda shell.bash hook)"
conda activate $condaenv

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
HOST_NAME=$(hostname)
echo "Tunnelling SSH command: ssh -o \"ServerAliveInterval 60\" -o \"ServerAliveCountMax 1200\" -L $PORT:$HOST_NAME.internal.sanger.ac.uk:$PORT ${USER}@ssh.sanger.ac.uk" >> jupyter_lab.log

echo setting proxys via environemnt variables for R: http_proxy, https_proxy, HTTP_PROXY, HTTPS_PROXY ...
export http_proxy=http://wwwcache.sanger.ac.uk:3128                                                                            
export https_proxy=http://wwwcache.sanger.ac.uk:3128                                                                           
export HTTP_PROXY=http://wwwcache.sanger.ac.uk:3128                                                                            
export HTTPS_PROXY=http://wwwcache.sanger.ac.uk:3128 

echo starting jupyter lab...
jupyter lab --notebook-dir=$notebookdir --port=$PORT --ip=0.0.0.0 >> jupyter_lab.log 2>&1
