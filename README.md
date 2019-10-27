# Keycloak for Computer Science House

Extends the Keycloak docker image to use PostgreSQL and allow reverse proxying, plus some additional tweaks for Computer Science House.

## Usage

### Start an instance

Start a Keycloak instance:

    docker run --name keycloak computersciencehouse/keycloak

### Environment Variables

When starting the Keycloak instance you can pass a number of environment variables to configure how it connects to PostgreSQL. For example:

    docker run --name keycloak -e POSTGRES_PORT_5432_TCP_ADDR=postgres.mycompany.com -e DB_DATABASE=keycloak -e DB_USER=keycloak -e DB_PASSWORD=password computersciencehouse/keycloak

##### KEYCLOAK_USER

Specify the initial admin user to create.

##### KEYCLOAK_PASSWORD

Specify the initial admin user's password.

##### POSTGRES\_PORT\_5432\_TCP\_ADDR

Specify the hostname of the PostgreSQL server.

##### POSTGRES\_PORT\_5432\_TCP\_PORT

Specify the port of the PostgreSQL server (optional, default is `5432`).

##### DB_DATABASE

Specify the name of the PostgreSQL database (optional, default is `keycloak`).

##### DB_USER

Specify the user for the PostgreSQL database (optional, default is `keycloak`).

##### DB_PASSWORD

Specify the password for the PostgreSQL database (optional, default is `password`).


