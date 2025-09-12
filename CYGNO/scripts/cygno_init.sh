#!/bin/bash

export CVMFS_PARENT_DIR=/jupyter-workspace

# RELEASE=`lsb_release -a | grep Release: | cut -f2`
# PYRELEASE=`python -V | cut -d " " -f2`

# export PACKAGE_DIR="Ubuntu${RELEASE}_Py${PYRELEASE}"
# export PYTHONPATH="${PYTHONPATH}:$CVMFS_PARENT_DIR/cvmfs/sft-cygno.infn.it/packages/py/$PACKAGE_DIR"

export PATH=$CVMFS_PARENT_DIR/cvmfs/sft-cygno.infn.it/script:$PATH
source $CVMFS_PARENT_DIR/cvmfs/sft.cern.ch/lcg/views/LCG_105/x86_64-ubuntu2204-gcc11-opt/setup.sh
source $CVMFS_PARENT_DIR/cvmfs/sft-cygno.infn.it/config/setup_digi.sh
if [ ! -L /usr/include/numpy ]; then
  ln -s $CVMFS_PARENT_DIR/cvmfs/sft.cern.ch/lcg/views/LCG_105/x86_64-ubuntu2204-gcc11-opt/lib/python3.9/site-packages/numpy/core/include/numpy/ /usr/include/numpy
fi
