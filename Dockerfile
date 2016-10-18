# computersciencehouse/keycloak
FROM jboss/keycloak:latest
MAINTAINER Steven Mirabito (smirabito@csh.rit.edu)

# Copy XSL patches into container
ADD changeDatabase.xsl changeProxy.xsl /opt/jboss/keycloak/

# Patch configuration for reverse proxy support
RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml \
-xsl:/opt/jboss/keycloak/changeDatabase.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml && \
java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml \
-xsl:/opt/jboss/keycloak/changeDatabase.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml && \
rm /opt/jboss/keycloak/changeDatabase.xsl

# Install and configure Keycloak for PostgreSQL
RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main && \
cd /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main && \
curl -O https://jdbc.postgresql.org/download/postgresql-9.4.1211.jar

ADD module.xml /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main/

RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml \
-xsl:/opt/jboss/keycloak/changeProxy.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml && \
java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml \
-xsl:/opt/jboss/keycloak/changeProxy.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml && \
rm /opt/jboss/keycloak/changeProxy.xsl

# Set permissions on the Wildfly standalone directory for OpenShift deployments
RUN chmod -R og+rwx /opt/jboss/keycloak/standalone

