#!/usr/bin/env bash

#cat << EOF > /etc/oidc-agent/issuer.config.d/iam-cygno
#{
#"issuer": "https://iam-cygno.cloud.cnaf.infn.it/",
#"register": "https://iam-cygno.cloud.cnaf.infn.it/manage/dev/dynreg",
#"legacy_aud_mode": true
#}
#EOF


export CVMFS_PARENT_DIR=/jupyter-workspace
export OIDC_AGENT=$CVMFS_PARENT_DIR/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/latest/bin/oidc-agent
export PATH=$PATH:$CVMFS_PARENT_DIR/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/latest/bin/
source $CVMFS_PARENT_DIR/cvmfs/datacloud.infn.it/sw/oidc-agent/ubuntu22.04/setup_oidc_agent_latest.sh

#export OIDC_CONFIG_DIR=$HOME/.oidc-agent
export OIDC_CONFIG_DIR=/jupyter-workspace/private/.oidc-agent

# eval $(oidc-keychain)
eval $(oidc-agent )

oidc-gen dodas --issuer "$IAM_SERVER" \
    --client-id "$IAM_CLIENT_ID" \
    --client-secret "$IAM_CLIENT_SECRET" \
    --rt "$REFRESH_TOKEN" \
    --audience=object \
    --confirm-yes \
    --scope "address phone openid profile compute.create offline_access compute.read compute.cancel compute.modify wlcg email wlcg.groups" \
    --redirect-uri http://localhost:8843 \
    --pw-cmd "echo \"DUMMY PWD\""

oidc-token dodas > /tmp/token

while true; do
    # Ottieni tempo alla scadenza del token in secondi
#    EXPIRY=$(oidc-token dodas --expiry)
     EXPIRY=$[`oidc-token dodas -e` - `date +%s`]
    # Se EXPIRY è valido e maggiore di 1800 secondi
    if [ "$EXPIRY" -gt 1800 ]; then
        # Dormi fino a 30 minuti prima della scadenza
        SLEEP_TIME=$((EXPIRY - 1800))
        sleep "$SLEEP_TIME"
    fi

    # Scrivi il token aggiornato
    oidc-token dodas > /tmp/token
done &
