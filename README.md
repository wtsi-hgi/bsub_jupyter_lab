## bsub_jupyter_lab
start jupyter lab (python and R) server on LSF farm5 node via bsub

#### instructions
ssh on farm5, clone repo and run start script with arguments:  
!This requires conda to be activated, see instructions below if not done already!
```
git clone https://github.com/wtsi-hgi/bsub_jupyter_lab.git && cd bsub_jupyter_lab
./bsub_jupyter_lab.sh -g hgi -c 4 -m 50000 -q normal
```

* `-g` is your LSF group
* `-c` is the number of CPUs requested
* `-m` is the memory requested (50000 means 50G)
* `-q` is the LSF queue

The address:port and token of the server will be given in file `jupyter_lab.log` (generated in current directory).
That is, wait until you see a line like the following in `jupyter_lab.log` , and paste address in your browser:
```
    Or copy and paste one of these URLs:
        http://node-10-4-1:53074/?token=ea9bba78eb0840154b45acfc90dc9395e66c8d6fbcb2d4be
```

#### R libraries
2 R versions are currently available in the notebook: R 3.6.1 and R 4.0.0 .  
You can add your own R installed packages (must be compatible with either R 3.6.1 or R 4.0.0) in an R notebook:
```
.libPaths(/lustre/path_to_installed_packages)
library(your_package_name)
```

#### activate hgi conda on farm5
```
ssh farm5-login
vvi@farm5-head2:~$ /software/hgi/installs/anaconda3/bin/conda init bash
<now you must log out and into farm5 again>
(base) vvi@farm5-head2:~$ conda activate hgi_base
```
