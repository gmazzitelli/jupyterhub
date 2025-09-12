#
# Image name: cygno-lab -> based on snj-base-lab-cc7
# docker build . -t gmazzitelli/cygno-lab:v2.X -f lab/Dockerfile 
#
FROM harbor.cloud.infn.it/datacloud-templates/snj-base-lab:1.3.0-1 

ARG JUPYTER_ROOT=/jupyter-workspace
ARG CVMFS_PARENT_DIR=/jupyter-workspace


COPY lab/config/bashrc /home/root/.bashrc
COPY lab/config/bash_profile /home/root/.bash_profile


## reclone CNAF
ARG AWS_SHARED_PATH=/home/root/.aws

COPY lab/config/aws_rclone.conf ${AWS_SHARED_PATH}/rclone.conf
COPY lab/config/aws_config ${AWS_SHARED_PATH}/config

ENV AWS_CONFIG_FILE=${AWS_SHARED_PATH}/config
ENV AWS_ENDPOINT_URL=https://s3.cr.cnaf.infn.it:7480
ENV AWS_ROLE_ARN=arn:aws:iam::cygno:role/IAMaccess
ENV IAM_ACCESS_TOKEN="<IAM token>"
ENV AWS_SHARED_PATH=${AWS_SHARED_PATH}

# install software (da libjpeg62 richieste simulazione)
RUN apt-get update && apt-get install -y cron \
    ca-certificates \
    libjpeg62 \   
    libcurl4-gnutls-dev \
    libgl1-mesa-dev \
    libmotif-dev \
    xorg-dev \
    fuse3



# install rclone CNAF altrimenti va messao 
# sudo -v ; curl https://rclone.org/install.sh | sudo bash
# in relta' di potrebbe rimuovere. 
RUN curl https://rclone.org/install.sh | bash
# RUN wget https://repo.cloud.cnaf.infn.it/repository/rclone/rclone-linux/2.0.0/rclone-linux-2.0.0 -O /bin/rclone
RUN chmod +x /bin/rclone


# install htcondor
COPY assets/condor.sh /tmp/condor.sh
RUN chmod +x /tmp/condor.sh && /tmp/condor.sh --no-dry-run 
COPY lab/config/condor_config.local /etc/condor/condor_config.local
# update condor certificate
COPY lab/config/htcondor_ca.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates


# postscript istallation

RUN jupyter labextension uninstall @jlab_collaborative_ext/context-menu

COPY scripts/post_script.sh /usr/local/share/dodasts/script/
RUN chmod +x /usr/local/share/dodasts/script/post_script.sh

COPY scripts/oidc_agent_init.sh /usr/local/share/dodasts/script/
RUN chmod +x /usr/local/share/dodasts/script/oidc_agent_init.sh

COPY scripts/cygno_init.sh /usr/local/share/dodasts/script/
RUN chmod +x /usr/local/share/dodasts/script/cygno_init.sh

COPY scripts/sts.py /usr/local/share/dodasts/script/
RUN chmod +x /usr/local/share/dodasts/script/sts.py

WORKDIR /usr/local/share/dodasts/script/

# Install Geant4
# COPY scripts/install_geant4.sh /usr/local/share/dodasts/script/
# RUN chmod +x /usr/local/share/dodasts/script/install_geant4.sh
#RUN ./install_geant4.sh
# Install garfield
# COPY scripts/install_garfield.sh /usr/local/share/dodasts/script/
# RUN chmod +x /usr/local/share/dodasts/script/install_garfield.sh
#RUN ./install_garfield.sh
# Install CADMesh
# COPY scripts/install_CADMesh.sh /usr/local/share/dodasts/script/
# RUN chmod +x /usr/local/share/dodasts/script/install_CADMesh.sh
#RUN ./install_CADMesh.sh
# Install RooUnfold
# COPY scripts/install_RooUnfold.sh /usr/local/share/dodasts/script/
# RUN chmod +x /usr/local/share/dodasts/script/install_RooUnfold.sh
#RUN ./install_RooUnfold.sh
# Install CYGNO-MC
# COPY scripts/install_CYGNO-MC.sh /usr/local/share/dodasts/script/
# RUN chmod +x /usr/local/share/dodasts/script/install_CYGNO-MC.sh
#RUN ./install_CYGNO-MC.sh

# setup general path

ENV CVMFS_PARENT_DIR=${CVMFS_PARENT_DIR}
ENV PATH=${CVMFS_PARENT_DIR}/cvmfs/sft-cygno.infn.it/config:$PATH
ENV PATH=${CVMFS_PARENT_DIR}/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/latest/bin:$PATH
ENV PYTHONPATH=${CVMFS_PARENT_DIR}/cvmfs/sft-cygno.infn.it/packages/py/Ubuntu22.04_Py3.11.9:/opt/conda/lib/python3.11/site-packages
ENV OIDC_LIB_PATH="$CVMFS_PARENT_DIR/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/latest/lib"
ENV LD_LIBRARY_PATH="$OIDC_LIB_PATH"


# Link folders

RUN ln -s ${CVMFS_PARENT_DIR}/cvmfs /cvmfs

RUN mkdir -p ${JUPYTER_ROOT} \
#    && ln -s /s3 ${JUPYTER_ROOT}/cloud-storage \
    && ln -s /cnaf ${JUPYTER_ROOT}/cnaf-storage \
#    && ln -s /ba ${JUPYTER_ROOT}/ba-storage \
    && ln -s /shared ${JUPYTER_ROOT}/shared \
    && ln -s /private ${JUPYTER_ROOT}/private

# Setting up kernel with CYGNO Setup
RUN ipython kernel install --name=cygno-setup
COPY lab/config/cygno_env.json /usr/local/share/jupyter/kernels/cygno-setup/kernel.json

# cean up

RUN rm -rf /var/lib/apt/lists/*; \
    apt-get purge -y --auto-remove; \
    apt-get autoremove; \
    apt-get clean;

WORKDIR ${JUPYTER_ROOT}


