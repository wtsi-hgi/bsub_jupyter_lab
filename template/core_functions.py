from core_decorators import *

import os
from os import *
import itertools
import logging
import pipeop
from logdecorator import log_on_start, log_on_end, log_on_error, log_exception
import wrapt

@subset_returned_generator # optional (n_max=integer) can be provided to return up to integer elements
def subset_generator(a_generator):
    """ function to subset a generator by applying the subset_returned_generator decorator"""
    return a_generator

def scantree(path):
    """lazy, recursively yield DirEntry objects for given directory."""
    for entry in scandir(path):
        if entry.is_dir(follow_symlinks=False):
            yield from scantree(entry.path) 
        else:
            yield entry
            
# fast function to get last line of file:
# requires str(readlastline(f), 'utf-8') to convert returned value to string of last line
def readlastline(f):
    f.seek(-2, 2)              # Jump to the second last byte.
    while f.read(1) != b"\n":  # Until EOL is found ...
        f.seek(-2, 1)          # ... jump back, over the read byte plus one more.
    return f.read()            # Read all data from this point on.