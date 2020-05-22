#!/usr/bin/env bash
set -e
set -u
set -o pipefail

while getopts 'g:c:m:q:' OPTION; do
  case "$OPTION" in
    g)
      lsf_group="$OPTARG"
      echo "LSF group is $lsf_group"
      ;;
    c)
      n_cpus="$OPTARG"
      echo "Number of requested CPUs is $n_cpus"
      ;;
    m)
      mem="$OPTARG"
      echo "LSF memory requested is $mem"
      ;;
    q)
      queue="$OPTARG"
      echo "LSF queue requested is $queue"
      ;;
  esac
done
shift "$(($OPTIND -1))"

echo starting bsub...
rm -f jupyter_lab.log
bsub -G ${lsf_group} \
     -R "select[mem>$mem] rusage[mem=$mem] span[hosts=1]" \
     -M ${mem} -n ${n_cpus} \
     -o jupyter_lab.log -e jupyter_lab.log \
     -q ${queue} \
     bash start_jupyter.sh > jupyter_lab.log
echo waiting for LSF job to start... >> jupyter_lab.log
echo finished bsub
echo see file jupyter_lab.log for jupyterhub IP address and port
