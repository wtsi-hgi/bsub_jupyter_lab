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

If you are working remotely, you need to be connected via VPN or use ssh tunneling to access the node from your web browser. With the latter, you need to :  
 - manually replace `[node].sanger.ac.uk` with `[node].internal.sanger.ac.uk` in the address.  
 - forward the port of the host that is running Jupyter Lab on to a port on your local machine. For the example above, open a new terminal session and do `ssh -L 53074:node-10-4-1.internal.sanger.ac.uk:53074 your_sanger_sername@ssh.sanger.ac.uk`, which forwards port 53074 on node-10-4-1 to port 53074 on your localhost, jumping through the SSH gateway.

#### R libraries
2 R versions are currently available in the notebook: R 3.6.1 and R 4.0.0 .  
You can add your own R installed libraries (must be compatible with either R 3.6.1 or R 4.0.0) in an R notebook:
```
.libPaths(/lustre/path_to_installed_libraries)
library(your_library_name)
```

#### python libraries
In Jupyter, you can open a terminal and try install packages with a `--target` directory,  e.g.    
    `pip install pandas --target /lustre/path_to_new_pip_libraries`  
and then in a python notebook:
```
    import sys
    sys.path.append('/lustre/path_to_new_pip_libraries')
    import pandas
```

If that doesn’t work for your package, contact HGI: you could clone the whole jupyter conda environment and reference the new one in the start script so that you can use any conda/pip command.
 

#### activate hgi conda on farm5
```
ssh farm5-login
vvi@farm5-head2:~$ /software/hgi/installs/anaconda3/bin/conda init bash
<now you must log out and into farm5 again>
vvi@farm5-head2:~$ conda activate hgi_base
```
