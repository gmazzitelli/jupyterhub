# Image name: cygno-lab-wn
# FROM htcondor/execute:8.9.9-el7


FROM ubuntu:22.04
USER root
WORKDIR /home/root

RUN apt update -y && apt install -y \
    build-essential \
    libcairo2-dev \
    libczmq-dev \
    libffi-dev \
    libjpeg-dev \
    libpixman-1-dev \
    wget curl python3-pip \
    ca-certificates \
    libjpeg62 \   
    libcurl4-gnutls-dev \
    libgl1-mesa-dev \
    libmotif-dev \
    libgfortran5 \
    xorg-dev

RUN python3 -m pip config set global.break-system-packages true
RUN python3 -m pip install --no-cache-dir \
        h5py \
        matplotlib \
        numpy \
        pandas 

RUN ln -s /cvmfs/sft.cern.ch/lcg/views/LCG_105/x86_64-ubuntu2204-gcc11-opt/lib/python3.9/site-packages/numpy/core/include/numpy/ /usr/include/numpy

ENV PATH=/cvmfs/datacloud.infn.it/sw/sts-wire/linux/2.1.5/bin:$PATH
ENV PATH=/cvmfs/sft-cygno.infn.it/config:$PATH
ENV PATH=/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/latest/bin:$PATH
ENV PYTHONPATH=/cvmfs/sft-cygno.infn.it/packages/py/Ubuntu22.04_Py3.11.9
