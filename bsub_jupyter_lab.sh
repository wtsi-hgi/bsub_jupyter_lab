#!/usr/bin/env bash

lsf_group=hgi
n_cpus=4
mem=50000 # 50000 means 50G
queue=normal

echo starting bsub...
rm -f jupyter_lab.log && \
    bsub -G ${lsf_group} \
	 -R "select[mem>$mem] rusage[mem=$mem] span[hosts=1]" \
	 -M ${mem} -n ${n_cpus} \
	 -o jupyter_lab.log -e jupyter_lab.log \
	 -q ${queue} \
	 bash start_jupyter.sh > jupyter_lab.log
echo waiting for LSF job to start... >> jupyter_lab.log
echo finished bsub
echo see file jupyter_lab.log for jupyterhub IP address and port
