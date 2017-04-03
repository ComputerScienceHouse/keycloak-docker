# computersciencehouse/keycloak
FROM jboss/keycloak:latest
MAINTAINER Steven Mirabito (smirabito@csh.rit.edu)

# Temporarily elevate permissions
USER root

# Copy XSL patches into container
ADD changeDatabase.xsl changeProxy.xsl theme.xsl /opt/jboss/keycloak/

# Patch configuration for PostgreSQL
RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml \
-xsl:/opt/jboss/keycloak/changeDatabase.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml && \
java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml \
-xsl:/opt/jboss/keycloak/changeDatabase.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml

# Install the PostgreSQL JDBC Driver
ADD https://jdbc.postgresql.org/download/postgresql-42.0.0.jar \
/opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main/postgresql-42.0.0.jar
ADD module.xml /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main/
RUN chown -R jboss:jboss /opt/jboss/keycloak/modules/system/layers/base/org/postgresql && \
chmod 644 /opt/jboss/keycloak/modules/system/layers/base/org/postgresql/jdbc/main/postgresql-42.0.0.jar

# Patch configuration for reverse proxy support
RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml \
-xsl:/opt/jboss/keycloak/changeProxy.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml && \
java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml \
-xsl:/opt/jboss/keycloak/changeProxy.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml

# Set permissions on the Wildfly standalone directory for OpenShift deployments
RUN chmod -R og+rwx /opt/jboss/keycloak/standalone

# Add Kerberos client config
ADD krb5.conf /etc/

# Install theme
ADD https://repo.csh.rit.edu/repository/raw/csh-material-login/theme/master/theme-master-latest.zip /opt/jboss/keycloak/csh-theme.zip
RUN cd /opt/jboss/keycloak && \
chown jboss:jboss csh-theme.zip && \
chmod 644 csh-theme.zip && \
/opt/jboss/keycloak/bin/jboss-cli.sh --command="module add --name=edu.rit.csh.theme --resources=csh-theme.zip" && \
java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml \
-xsl:/opt/jboss/keycloak/theme.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml && \
java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml \
-xsl:/opt/jboss/keycloak/theme.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml

# Drop permissions
USER jboss

