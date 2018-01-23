# computersciencehouse/keycloak
FROM jboss/keycloak:latest
MAINTAINER Steven Mirabito (smirabito@csh.rit.edu)

# Temporarily elevate permissions
USER root

# Copy customizations into container
ADD customization /opt/jboss/keycloak/customization

# Download theme
ADD https://repo.csh.rit.edu/repository/raw/csh-material-login/theme/master/theme-master-latest.zip /opt/jboss/keycloak/csh-theme.zip
RUN cd /opt/jboss/keycloak && \
chown jboss:jboss csh-theme.zip && \
chmod 644 csh-theme.zip

# Execute customization script
RUN cd /opt/jboss/keycloak && \
/opt/jboss/keycloak/customization/execute.sh

# Add Kerberos client config
ADD krb5.conf /etc/

# Set permissions on the Wildfly standalone directory for OpenShift deployments
RUN chown -R jboss:0 $JBOSS_HOME/standalone && \
    chmod -R g+rw $JBOSS_HOME/standalone && \
    chown -R jboss:0 $JBOSS_HOME/modules/system/layers/base && \
    chmod -R g+rw $JBOSS_HOME/modules/system/layers/base && \
    chown -R jboss:0 /tmp && \
    chmod -R g+rw /tmp

# Drop permissions
USER jboss

