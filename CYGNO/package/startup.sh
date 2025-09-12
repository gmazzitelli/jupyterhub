#/bin/bash

RELEASE=`lsb_release -a | grep Release: | cut -f2`

PYRELEASE=`python -V | cut -d " " -f2`

export PACKAGE_DIR="Ubuntu${RELEASE}_Py${PYRELEASE}"

# export PYTHONPATH="${PYTHONPATH}:$CVMFS_PARENT_DIR/cvmfs/sft-cygno.infn.it/packages/py/$PACKAGE_DIR"

export PYTHONPATH="/mnt/py/$PACKAGE_DIR"

env

date

#sleep infinity
