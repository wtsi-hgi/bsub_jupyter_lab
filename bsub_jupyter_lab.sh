#!/usr/bin/env bash
set -e
set -u
set -o pipefail

# defaults
notebookdir=$PWD
condaenv=/software/hgi/installs/anaconda3/envs/nextflow20

while getopts 'g:c:m:q:d:e:' OPTION; do
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
    d)
      notebookdir="$OPTARG"
      ;; 
    e)
      condaenv="$OPTARG"
      ;;
  esac
done
shift "$(($OPTIND -1))"

echo starting bsub...
rm -f jupyter_lab.log
echo "notebook dir will be $notebookdir"
echo "jupyter lab conda env is $condaenv"

if [[ $queue == *"gpu"* ]]; 
  then
    bsub -G ${lsf_group} \
        -R"select[ngpus>0 && mem>$mem] rusage[ngpus_physical=3,mem=$mem] span[ptile=1]" -gpu "mode=exclusive_process" \
        -M ${mem} -n ${n_cpus} \
        -o jupyter_lab.log -e jupyter_lab.log \
        -q ${queue} \
        bash start_jupyter.sh -d $notebookdir -e $condaenv > jupyter_lab.log
  else
    bsub -G ${lsf_group} \
        -R "select[mem>$mem] rusage[mem=$mem] span[hosts=1]" \
        -M ${mem} -n ${n_cpus} \
        -o jupyter_lab.log -e jupyter_lab.log \
        -q ${queue} \
        bash start_jupyter.sh -d $notebookdir -e $condaenv > jupyter_lab.log
fi

echo waiting for LSF job to start... >> jupyter_lab.log
echo finished bsub
echo see file jupyter_lab.log for jupyterhub IP address and port
tail -f jupyter_lab.log
