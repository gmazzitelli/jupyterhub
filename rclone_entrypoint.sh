#!/bin/sh

# Mostra il contenuto del template per il debug
# cat /config/rclone.conf.template

# Sostituire le variabili d'ambiente nel file di configurazione usando sed
sed 's|${RCLONE_KEY_ID}|'"$RCLONE_KEY_ID"'|g' /config/rclone.conf.template | \
sed 's|${RCLONE_KEY}|'"$RCLONE_KEY"'|g' | \
sed 's|${RCLONE_ENDPOINT}|'"$RCLONE_ENDPOINT"'|g' > /config/rclone.conf

# Mostra il contenuto del file di configurazione per il debug
# cat /config/rclone.conf

# Avvia il comando rclone con i parametri passati
exec rclone "$@"
