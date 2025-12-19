## Build extension with java image keycloak is based on
FROM docker.io/gradle:jdk11-ubi9 AS totp-build

# Elevate for the build
USER root

# Install git
RUN microdnf install -y git

# Clone git repo
RUN git clone --depth 1 --branch v1.0.0 https://github.com/medihause/keycloak-totp-api /keycloak-totp-api
WORKDIR /keycloak-totp-api

# Build
RUN gradle --no-daemon shadowJar

## computersciencehouse/keycloak
FROM quay.io/keycloak/keycloak:19.0.2
MAINTAINER Computer Science House (rtp@csh.rit.edu)

ARG THEME_VERSION=2.0.1

WORKDIR /opt/keycloak
# Temporarily elevate permissions
USER root

# Download theme
ADD https://s3.csh.rit.edu/csh-material-login/csh-material-login_$THEME_VERSION.jar \
    ./providers
COPY --from=totp-build /keycloak-totp-api/build/libs/keycloak-totp-api-1.0.0-all.jar ./providers

# Add Kerberos client config
ADD krb5.conf /etc/
ADD https://ipa10-nrh.csh.rit.edu/ipa/config/ca.crt /etc/ipa/ca.crt

# Set permissions on the Wildfly standalone directory for OpenShift deployments
RUN chown -R keycloak:0 /tmp && \
  chmod -R g+rw /tmp && \
  chmod -R 774 ./data ./providers && \
  chown -R keycloak:0 ./data ./providers

# Drop permissions
USER keycloak

