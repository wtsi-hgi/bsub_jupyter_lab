## bsub jupyter lab
start jupyter lab (python and R) server on LSF farm5 node, i.e. notebooks with access to /lustre, via bsub.  
This page has several sections:  
- [How to start jupyter lab](#instructions)
- [How to use your own R libraries](#R-libraries)
- [How to install your own R libraries in your project or home dir](#How-to-install-your-own-libraries-in-your-project-or-home-dir)
- [How to use your own python libraries](#python-libraries)
- [How to set up a personal jupyter lab conda environment](#jupyterlab-conda-env)
- [How to set up a personal jupyter lab conda environment with your own R kernel](#jupyterlab-conda-env-r-kernel)
- [How to copy data to/from personal computer to Sanger /lustre without VPN](#How-to-copy-data-to-or-from-personal-computer-to-Sanger-lustre-without-VPN)
- [How to activate hgi conda on farm5](#activate-hgi-conda-on-farm5)

#### instructions
ssh on farm5, clone repo and run start script with arguments:  
! This requires conda to be activated, see [instructions below](#activate-hgi-conda-on-farm5) if not done already !
```
git clone https://github.com/wtsi-hgi/bsub_jupyter_lab.git && cd bsub_jupyter_lab
./bsub_jupyter_lab.sh -g hgi -c 4 -m 50000 -q normal
```

* `-g` is **your LSF group** (not *hgi*)
* `-c` is the number of CPUs requested
* `-m` is the memory requested (50000 means 50G)
* `-q` is the LSF queue
  
there are also 2 optional arguments
* `-d` /lustre/path_to_notebook_dir (to set notebook's browser directory)
* `-e` /lustre/path_to_conda_env (to use your own jupyter lab conda env, see  [instructions below](#jupyterlab-conda-env) to create)

The address:port and token of the server will be given in file `jupyter_lab.log` (created in current directory).
That is, wait until you see a line like the following in `jupyter_lab.log` , and paste address in your browser:
```
    Or copy and paste one of these URLs:
        http://node-10-4-1:53074/?token=ea9bba78eb0840154b45acfc90dc9395e66c8d6fbcb2d4be
```

If you are working remotely, you need to be connected via VPN or use [SSH tunneling through the web proxy](https://ssg-confluence.internal.sanger.ac.uk/display/FARM/All+things+SSH#AllthingsSSH-TunnelingthroughtheSSHgateway) to access the node from your web browser.   
With the latter, you only need to forward the port of the host that is running Jupyter Lab on to a port on your local machine:
To do so,
1) In a terminal, **run the Tunnelling SSH command** that you will find in log file `jupyter_lab.log` 
(for the example above, that would be 
`ssh -L 53074:node-10-4-1.internal.sanger.ac.uk:53074 your_sanger_username@ssh.sanger.ac.uk`,  
which forwards port 53074 on node-10-4-1 to port 53074 on your localhost, jumping through the SSH gateway.)
2) Point your **browser** to the address `127.0.0.1` that is also shown in `jupyter_lab.log` (for example, 
`http://127.0.0.1:53074/?token=ea9bba78eb0840154b45acfc90dc9395e66c8d6fbcb2d4be`).

#### R libraries

HGI R doc:
https://confluence.sanger.ac.uk/display/HGI/Software+on+the+Farm#SoftwareontheFarm-R

2 R versions are currently available in the notebook: R 3.6.1 and R 4.0.0 .  
You can add your own installed libraries (must be compatible with either R 3.6.1 or R 4.0.0) in an R notebook:
```
.libPaths(/lustre/path_to_installed_libraries)
library(your_library_name)
```

##### How to install your own libraries in your project or home dir

```
# set local/personal libs directory, e.g.:
R_version = paste0(as.character(R.version['major']),
       '.', as.character(R.version['minor']))
local_libs = paste0('~/personal_rlibs_R_',R_version) # can be changed to any new dir in your home dir or project area

# create directory if doesn't exist already:
dir.create(local_libs, showWarnings = FALSE)
# tell R to use this libs directory
.libPaths(local_libs)
# Install BiocManager if not done already:
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager", lib=local_libs, repos='http://cran.us.r-project.org')
BiocManager::install(lib=local_libs)

# now R is ready to install packages in local_libs
# example install of a package in local_libs directory via Bioconductor:
BiocManager::install('purrr', lib=local_libs)

# example install of a package in local_libs directory without Bioconductor:
install.packages("anocva", lib=local_libs, repos='http://cran.us.r-project.org')

# test that libraries are there and loaded correctly
library(purrr)
library(anocva)
# check that local_libs directory indeed has `purrr` and `anocva` dirs:
list.files(local_libs)

# in future sessions, don't forget to run .libPaths(local_libs) so that R can load these libraries.
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
If that gives conflict errors with the packages already installed, you can create and use your own jupyter-lab/python conda environment, see [instructions below](#jupyterlab-conda-env).

#### How to copy data to or from personal computer to Sanger lustre without VPN
This, and all SSH related issues, are documented at https://ssg-confluence.internal.sanger.ac.uk/display/FARM/All+things+SSH .   
In short, you can use `rsync`.  
First, in a terminal, run:
```
ssh -L2222:farm5-login.internal.sanger.ac.uk:22 your_username@ssh.sanger.ac.uk 
```
where `your_username` is your Sanger username. 
It should ask for your Sanger ssh password and ask where you want to go (enter `farm5-login`). 
Once connected, keep that terminal open, and in a new one run the `rsync` command to copy your files:
```
rsync -rvz -e 'ssh -p 2222' --progress local_file_to_copy your_username@localhost:/lustre/path_where_you_want_the_files_to_go/
```

#### jupyterlab conda env
You can also use your own conda environment, so that you can install any conda/pip/R packages directly in the environment.
Create a new minimal environment with (or use `minimal_conda_env.txt`) :
```
conda create --prefix /lustre/path_to_your_new_env/jupyterlab_env -c conda-forge jupyterlab
```
and use optional argument `-e`of script `./bsub_jupyter_lab.sh` to reference it.

#### jupyterlab conda env R kernel
You can also use your own conda environment + your own R kernel (that will use R from the new conda env):
```
 
# full setup of your own Jupiter lab + R kernel environment:
 
# choose a path you have access to (/lustre/somewhere or preferably /software/somewhere if you can):
export INSTALL_DIR=/lustre/scratch118/humgen/hgi/users/mercury/test
 
# first, clone jupyter repo in INSTALL_DIR (this is important later on to setup the new R kernel config):
cd $INSTALL_DIR
git clone https://github.com/wtsi-hgi/bsub_jupyter_lab.git
 
# now, install your own jupyterlab conda environment, also in INSTALL_DIR:
conda create --prefix $INSTALL_DIR/jupyterlab_env -c conda-forge jupyterlab
 
# check that environment can be loaded ok:
conda activate $INSTALL_DIR/jupyterlab_env
 
#  now, you need to add your own R jupyter kernel in that new conda env:
# first, add R to the conda env:
conda install -c conda-forge r-base # this should instal R version 4 (let me know if you wanted a different version here).
# next add R kernel and tell jupyter lab configuration about it:
# check which R will be used by default
which R # in my case it will say “/lustre/scratch118/humgen/hgi/users/mercury/test/jupyterlab_env/bin/R” which is good because I want it to be in from my INSTALL_DIR
# go into R
R
# check that R default library path is in INSTALL_DIR
.libPaths() # in my case it will say [1] "/lustre/scratch118/humgen/hgi/users/mercury/test/jupyterlab_env/lib/R/library"
# now install the IRkernel package in that default location
install.packages('IRkernel')
IRkernel::installspec(displayname = 'Rperso')  # to register the kernel in the current R installation
# That command will install the R kernel in your home dir
# in my case, it said [InstallKernelSpec] Installed kernelspec ir in /nfs/users/nfs_m/mercury/.local/share/jupyter/kernels/ir
 
# now exit R, and copy that kernel config from your home directory to the bsub_jupyter_lab directory you just cloned:
cp -r ~/.local/share/jupyter/kernels/ir $INSTALL_DIR/bsub_jupyter_lab/kernels/
 
# check that you can use your new conda env via jupyter notebook, and that it sees your personal R kernel:
cd bsub_jupyter_lab
./bsub_jupyter_lab.sh -g hgi -c 4 -m 50000 -q normal -e $INSTALL_DIR/jupyterlab_env
# notice I used the -e option, and please replace -g with our own farm5 LSF group (not ‘hgi’).
# open your browser to the jupyter lab URL, and check that you see R kernel 'Rperso'
 
# You should see the “Rperso” kernel available in the list of kernels, and R command .libPaths() should point to the R library path in your new conda env.
 
# now you can install any other library in your environment!
# also, if you need rstudio shortcuts, you will need: jupyter labextension install @techrah/text-shortcuts
```

#### activate hgi conda on farm5
```
ssh farm5-login
gn5@farm5-head2:~$ /software/hgi/installs/anaconda3/bin/conda init bash
<now you must log out and into farm5 again>
<check that conda activate works:>
gn5@farm5-head2:~$ conda activate hgi_base
```
