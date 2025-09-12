#!/usr/bin/env bash

export CVMFS_PARENT_DIR=/jupyter-workspace
export OIDC_AGENT=$CVMFS_PARENT_DIR/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/latest/bin/oidc-agent
export PATH=$PATH:$CVMFS_PARENT_DIR/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/latest/bin/
source $CVMFS_PARENT_DIR/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/setup_oidc_agent_latest.sh

#export OIDC_CONFIG_DIR=$HOME/.oidc-agent
export OIDC_CONFIG_DIR=/jupyter-workspace/private/.oidc-agent

eval $(oidc-keychain)

oidc-gen dodas --issuer "$IAM_SERVER" \
    --client-id "$IAM_CLIENT_ID" \
    --client-secret "$IAM_CLIENT_SECRET" \
    --rt "$REFRESH_TOKEN" \
    --audience=object \
    --confirm-yes \
    --scope "address phone openid profile compute.create offline_access compute.read compute.cancel compute.modify wlcg email wlcg.groups" \
    --redirect-uri http://localhost:8843 \
    --pw-cmd "echo \"DUMMY PWD\""

while true; do
    # Ottieni tempo alla scadenza del token in secondi
    EXPIRY=$(oidc-token dodas --expiry)

    # Se EXPIRY è valido e maggiore di 1800 secondi
    if [ "$EXPIRY" -gt 1800 ]; then
        # Dormi fino a 30 minuti prima della scadenza
        SLEEP_TIME=$((EXPIRY - 1800))
        sleep "$SLEEP_TIME"
#    else
#        # Se sta per scadere, rigenera subito
#        echo "Token sta per scadere, rigenero ora"
    fi

    # Scrivi il token aggiornato
    oidc-token dodas --time 1200 > /tmp/token
done &



#while true; do
#    oidc-token dodas --time 1200 > /tmp/token
#    sleep 600
#done &
