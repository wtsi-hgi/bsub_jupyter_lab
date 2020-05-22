# bsub_jupyter_lab
start jupyter lab (python and R) server on LSF farm5 node via bsub

### instructions
clone repo and run start script with arguments:
```
git clone https://github.com/wtsi-hgi/bsub_jupyter_lab.git && cd bsub_jupyter_lab
bsub_jupyter_lab.sh -g hgi -c 4 -m 50000 -q normal
```

* `-g` is your LSF group
* `-c` is the number of CPUs requested
* `-m` is the memory requested (50000 means 50G)
* `-q` is the lSF queue

The address:port and token of the server will be given in file `jupyter_lab.log` (generated in current directory).

#### R libraries
You can add your own R installed packages (must be compatible with R3.6) in the R notebook:
```
.libPaths(/lustre/path_to_installed_packages)
library(your_package_name)
```
