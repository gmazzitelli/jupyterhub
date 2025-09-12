#!/usr/bin/env bash

# export CVMFS_PARENT_DIR=/jupyter-workspace
export PATH=$PATH:$CVMFS_PARENT_DIR/cvmfs/datacloud.infn.it/sw/sts-wire/linux/2.1.5/bin
# export PATH=$PATH:$CVMFS_PARENT_DIR/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/latest/bin/
source /usr/local/share/dodasts/script/oidc_agent_init.sh

#
source /usr/local/share/dodasts/script/cygno_init.sh &
#

# S3 MINIO

BASE_CACHE_DIR="/usr/local/share/dodasts/sts-wire/cache"

mkdir -p "${BASE_CACHE_DIR}"
mkdir -p /var/log/sts-wire/

#mkdir -p /s3/"${USERNAME}"
#mkdir -p /s3/scratch
#mkdir -p /s3/cygno-analysis
#mkdir -p /s3/cygno-sim
#mkdir -p /s3/cygno-data

# s3 CNAF
mkdir -p /cnaf/"${USERNAME}"
mkdir -p /cnaf/cygno-analysis
mkdir -p /cnaf/cygno-sim
mkdir -p /cnaf/cygno-data

# S3 MINIO
#sleep 1s && nice -n 19 sts-wire https://iam-cygno.cloud.cnaf.infn.it/ \
#    cygno_analysis https://minio.cloud.infn.it/ IAMaccess object \
#    /cygno-analysis /s3/cygno-analysis \
#    --localCache full --tryRemount --noDummyFileCheck \
#    --localCacheDir "${BASE_CACHE_DIR}/cygno_analysis" \
#    &>/var/log/sts-wire/mount_log_cygnoalanysis.txt &
#sleep 1s && nice -n 19 sts-wire https://iam-cygno.cloud.cnaf.infn.it/ \
#    cygno_sim https://minio.cloud.infn.it/ IAMaccess object \
#    /cygno-sim /s3/cygno-sim \
#    --localCache full --tryRemount --noDummyFileCheck \
#    --localCacheDir "${BASE_CACHE_DIR}/cygno_sim" \
#    &>/var/log/sts-wire/mount_log_cygnosim.txt &
#sleep 1s && nice -n 19 sts-wire https://iam-cygno.cloud.cnaf.infn.it/ \
#    cygno_data https://minio.cloud.infn.it/ IAMaccess object \
#    /cygno-data /s3/cygno-data \
#    --localCache full --tryRemount --noDummyFileCheck \
#    --localCacheDir "${BASE_CACHE_DIR}/cygno_data" \
#    &>/var/log/sts-wire/mount_log_cygnodata.txt &

set -e

# Primo mount
nice -n 19 rclone mount --config ${AWS_SHARED_PATH}/rclone.conf  \
     cygno:cygno:cygno-data /cnaf/cygno-data/ --daemon \
     --vfs-cache-mode writes \
     --cache-dir ${BASE_CACHE_DIR}/cygno_data \
     --daemon-timeout 30s \
     --log-file /var/log/sts-wire/mount_log_cygno_data_canf.txt

sleep 2

# Secondo mount
nice -n 19 rclone mount --config ${AWS_SHARED_PATH}/rclone.conf  \
     cygno:cygno:cygno-analysis /cnaf/cygno-analysis/ --daemon \
     --vfs-cache-mode writes \
     --cache-dir ${BASE_CACHE_DIR}/cygno_analysis \
     --daemon-timeout 30s \
     --log-file /var/log/sts-wire/mount_log_cygno_analysis_canf.txt

sleep 2

# Terzo mount
nice -n 19 rclone mount --config ${AWS_SHARED_PATH}/rclone.conf  \
     cygno:cygno:cygno-sim /cnaf/cygno-sim/ --daemon \
     --vfs-cache-mode writes \
     --cache-dir ${BASE_CACHE_DIR}/cygno_sim \
     --daemon-timeout 30s \
     --log-file /var/log/sts-wire/mount_log_cygno_sim_canf.txt

sleep 2

# Quarto mount
nice -n 19 rclone mount --config ${AWS_SHARED_PATH}/rclone.conf  \
     cygno:cygno:"${USERNAME}" /cnaf/"${USERNAME}" --daemon \
     --vfs-cache-mode writes \
     --cache-dir ${BASE_CACHE_DIR}/"${USERNAME}" \
     --daemon-timeout 30s \
     --log-file /var/log/sts-wire/mount_log_"${USERNAME}".txt




# Start crond
cron
