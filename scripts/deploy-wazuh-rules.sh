#!/bin/bash
set -e

TMP_FILE="/tmp/local_rules.xml.tmp"
STAGING_FILE="/var/ossec/etc/rules/local_rules.tmp.xml"
PROD_FILE="/var/ossec/etc/rules/local_rules.xml"

# Move to staging and validate
if [ ! -f "$TMP_FILE" ]; then
    echo "ERROR: Temp file $TMP_FILE not found. Was the scp transfer successful?"
    exit 1
fi
mv "$TMP_FILE" "$STAGING_FILE"
if ! /var/ossec/bin/wazuh-analysisd -t; then
    echo "Validation failed! Reverting changes..."
    rm -f "$STAGING_FILE"
    exit 1
fi

# Publish rules
if [ ! -f "$STAGING_FILE" ]; then
    echo "ERROR: Staging file $STAGING_FILE not found after validation."
    exit 1
fi
mv "$STAGING_FILE" "$PROD_FILE"
chown root:wazuh $PROD_FILE
chmod 660 $PROD_FILE

# Restart Wazuh
systemctl restart wazuh-manager
systemctl is-active wazuh-manager
