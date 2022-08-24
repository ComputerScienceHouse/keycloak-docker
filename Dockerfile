# computersciencehouse/keycloak
FROM quay.io/keycloak/keycloak:19.0.0
MAINTAINER Computer Science House (rtp@csh.rit.edu)

ARG THEME_VERSION=2.0.0

WORKDIR /opt/keycloak
# Temporarily elevate permissions
USER root

# Download theme
ADD https://s3.csh.rit.edu/csh-material-login/csh-material-login_$THEME_VERSION.jar \
    ./themes

# Add Kerberos client config
ADD krb5.conf /etc/
ADD https://ipa10-nrh.csh.rit.edu/ipa/config/ca.crt /etc/ipa/ca.crt

# Set permissions on the Wildfly standalone directory for OpenShift deployments
RUN chown -R keycloak:0 /tmp && \
  chmod -R g+rw /tmp && \
  chmod -R 774 ./data && \
  chown -R keycloak:0 ./data

# Drop permissions
USER keycloak

