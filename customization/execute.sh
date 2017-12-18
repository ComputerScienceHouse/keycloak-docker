#!/bin/bash
JBOSS_HOME=/opt/jboss/keycloak
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh

echo "=> Executing customization script"
$JBOSS_CLI --file=$JBOSS_HOME/customization/custom.cli
$JBOSS_CLI --file=$JBOSS_HOME/customization/custom-ha.cli
