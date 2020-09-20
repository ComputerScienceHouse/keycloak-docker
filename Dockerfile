# computersciencehouse/keycloak
FROM jboss/keycloak:11.0.2
MAINTAINER Computer Science House (rtp@csh.rit.edu)

ARG THEME_VERSION=2.0.0

# Temporarily elevate permissions
USER root

# Download theme
ADD https://s3.csh.rit.edu/csh-material-login/csh-material-login_$THEME_VERSION.jar \
    $JBOSS_HOME/standalone/deployments/

# Add Kerberos client config
ADD krb5.conf /etc/
ADD https://ipa10-nrh.csh.rit.edu/ipa/config/ca.crt /etc/ipa/ca.crt

# Set permissions on the Wildfly standalone directory for OpenShift deployments
RUN chown -R jboss:0 $JBOSS_HOME/standalone && \
    chmod -R g+rw $JBOSS_HOME/standalone && \
    chown -R jboss:0 $JBOSS_HOME/modules/system/layers/base && \
    chmod -R g+rw $JBOSS_HOME/modules/system/layers/base && \
    chown -R jboss:0 /tmp && \
    chmod -R g+rw /tmp

# Drop permissions
USER jboss

