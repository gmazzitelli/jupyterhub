#!/usr/bin/env bash

set -Eeuo pipefail

echo "[DBG] starting agent"
export CVMFS_PARENT_DIR=/jupyter-workspace

export OIDC_CONFIG_DIR=/jupyter-workspace/private/.oidc-agent

eval $(/usr/bin/oidc-agent)

TOKEN_FILE=/tmp/token

# Rimuovi un vecchio token vuoto o invalido
[ -s "$TOKEN_FILE" ] || rm -f "$TOKEN_FILE"

while true; do
    echo "[INFO] Generating OIDC account configuration..."
    /usr/bin/oidc-gen dodas --issuer "$IAM_SERVER" \
        --client-id "$IAM_CLIENT_ID" \
        --client-secret "$IAM_CLIENT_SECRET" \
        --rt "$REFRESH_TOKEN" \
        --audience=object \
        --confirm-yes \
        --scope "address phone openid profile compute.create offline_access compute.read compute.cancel compute.modify wlcg email wlcg.groups" \
        --redirect-uri http://localhost:8843 \
        --pw-cmd "echo 'DUMMY PWD'" || {
            echo "[WARN] oidc-gen failed; retrying in 5 seconds..."
            sleep 5
            continue
        }

    echo "[INFO] Requesting OIDC token..."
    if /usr/bin/oidc-token dodas > "$TOKEN_FILE" 2>/dev/null; then
        if [ -s "$TOKEN_FILE" ]; then
            echo "[SUCCESS] Token successfully written to $TOKEN_FILE"
            break
        else
            echo "[WARN] Token file is empty; retrying in 5 seconds..."
        fi
    else
        echo "[WARN] oidc-token failed; retrying in 5 seconds..."
    fi

    sleep 5
done

while true; do
    # Ottieni tempo alla scadenza del token in secondi
    EXPIRY=$[`/usr/bin/oidc-token dodas -e` - `date +%s`]
    # Se EXPIRY è valido e maggiore di 1800 secondi
    if [ "$EXPIRY" -gt 1800 ]; then
        # Dormi fino a 30 minuti prima della scadenza
        SLEEP_TIME=$((EXPIRY - 1800))
        sleep "$SLEEP_TIME"
    fi

    # Scrivi il token aggiornato
    /usr/bin/oidc-token dodas > /tmp/token
done &
