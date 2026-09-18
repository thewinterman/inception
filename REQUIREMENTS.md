# Inception Requirements

## Project Structure

- [ ] Complete the project on a virtual machine.
- [ ] Keep all configuration files under `srcs/`.
- [x] Provide a root `Makefile` that builds and starts the application through `docker-compose.yml`.
- [x] Use Docker Compose.
- [x] Write one Dockerfile per service and build every service image yourself.
- [x] Name each Docker image after its corresponding service.
- [x] Base images on the penultimate stable Alpine or Debian release.
- [x] Do not pull ready-made service images or use Docker Hub services, except Alpine or Debian base images.
- [x] Do not use the `latest` image tag.

## Mandatory Services

- [x] Run each service in its own dedicated container.
- [x] Configure an NGINX-only container with TLSv1.2 or TLSv1.3 only.
- [x] Configure a WordPress + php-fpm-only container, without NGINX.
- [x] Configure a MariaDB-only container, without NGINX.
- [x] Configure NGINX as the sole external entrypoint, exposed only on port `443`.
- [x] Create a Docker network that connects the containers and declare the network in `docker-compose.yml`.
- [x] Configure containers to restart after a crash.

## Persistence

- [x] Create one Docker named volume for the WordPress database.
- [x] Create a second Docker named volume for WordPress website files.
- [x] Do not use bind mounts for these persistent volumes.
- [x] Configure both named volumes to store host data below `/home/<login>/data`.

## Networking and Runtime Rules

- [ ] Configure `<login>.42.fr` to resolve to the local IP address.
- [x] Do not use `network: host`, `--link`, or `links`.
- [x] Do not keep containers alive with `tail -f`, `bash`, `sleep infinity`, `while true`, or another artificial infinite-loop command.
- [x] Run the actual foreground service as PID 1 using Dockerfile and entrypoint best practices.

## WordPress Data

- [x] Create at least two WordPress users in the database.
- [x] Make one of these users an administrator.
- [x] Ensure the administrator username does not contain `admin` or `administrator`, in any listed case variation.

## Configuration and Secrets

- [x] Use environment variables for configuration.
- [x] Provide a `srcs/.env` file for environment variables such as the domain name.
- [x] Keep passwords out of Dockerfiles.
- [ ] Store credentials, passwords, API keys, and other confidential values locally outside version control.
- [x] Add confidential files to `.gitignore`.
- [x] Prefer properly configured Docker secrets for confidential values.

## Required Documentation

- [x] Write `README.md` in English.
- [x] Make the README first line italicized and exactly state that the project was created as part of the 42 curriculum by the relevant login(s).
- [x] Include a `Description` section with the goal and a brief overview.
- [x] Explain the use of Docker, included sources, and the main design choices.
- [x] Compare virtual machines with Docker.
- [x] Compare secrets with environment variables.
- [x] Compare Docker networks with host networking.
- [x] Compare Docker volumes with bind mounts.
- [x] Include an `Instructions` section with relevant build, installation, and execution details.
- [x] Include a `Resources` section with conventional references and an explanation of AI use, including tasks and project parts.

## User Documentation

- [ ] Provide `USER_DOC.md` at the repository root.
- [ ] Describe the services provided by the stack.
- [ ] Explain how to start and stop the project.
- [ ] Explain how to access the website and WordPress administration panel.
- [ ] Explain how to locate and manage credentials.
- [ ] Explain how to verify that services are running correctly.

## Developer Documentation

- [ ] Provide `DEV_DOC.md` at the repository root.
- [ ] Describe environment setup from scratch, including prerequisites, configuration files, and secrets.
- [ ] Explain how to build and launch with the Makefile and Docker Compose.
- [ ] Document relevant container and volume management commands.
- [ ] Identify persistent-data locations and explain persistence.

## Bonus Options

_Bonus is assessed only when every mandatory requirement is completed and functioning correctly._

- [ ] Add a Redis cache for WordPress.
- [ ] Add an FTP server that accesses the WordPress files volume.
- [ ] Add a simple static website using a language other than PHP.
- [ ] Add Adminer.
- [ ] Add and justify another useful service.
- [ ] Give every bonus service its own Dockerfile, container, and any required dedicated volume.
- [ ] Open additional ports only when required by bonus services.
