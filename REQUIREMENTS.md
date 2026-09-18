# Inception Requirements

## Project Structure

- [ ] Complete the project on a virtual machine.
- [ ] Keep all configuration files under `srcs/`.
- [ ] Provide a root `Makefile` that builds and starts the application through `docker-compose.yml`.
- [ ] Use Docker Compose.
- [ ] Write one Dockerfile per service and build every service image yourself.
- [ ] Name each Docker image after its corresponding service.
- [ ] Base images on the penultimate stable Alpine or Debian release.
- [ ] Do not pull ready-made service images or use Docker Hub services, except Alpine or Debian base images.
- [ ] Do not use the `latest` image tag.

## Mandatory Services

- [ ] Run each service in its own dedicated container.
- [ ] Configure an NGINX-only container with TLSv1.2 or TLSv1.3 only.
- [ ] Configure a WordPress + php-fpm-only container, without NGINX.
- [ ] Configure a MariaDB-only container, without NGINX.
- [ ] Configure NGINX as the sole external entrypoint, exposed only on port `443`.
- [ ] Create a Docker network that connects the containers and declare the network in `docker-compose.yml`.
- [ ] Configure containers to restart after a crash.

## Persistence

- [ ] Create one Docker named volume for the WordPress database.
- [ ] Create a second Docker named volume for WordPress website files.
- [ ] Do not use bind mounts for these persistent volumes.
- [ ] Configure both named volumes to store host data below `/home/<login>/data`.

## Networking and Runtime Rules

- [ ] Configure `<login>.42.fr` to resolve to the local IP address.
- [ ] Do not use `network: host`, `--link`, or `links`.
- [ ] Do not keep containers alive with `tail -f`, `bash`, `sleep infinity`, `while true`, or another artificial infinite-loop command.
- [ ] Run the actual foreground service as PID 1 using Dockerfile and entrypoint best practices.

## WordPress Data

- [ ] Create at least two WordPress users in the database.
- [ ] Make one of these users an administrator.
- [ ] Ensure the administrator username does not contain `admin` or `administrator`, in any listed case variation.

## Configuration and Secrets

- [ ] Use environment variables for configuration.
- [ ] Provide a `srcs/.env` file for environment variables such as the domain name.
- [ ] Keep passwords out of Dockerfiles.
- [ ] Store credentials, passwords, API keys, and other confidential values locally outside version control.
- [ ] Add confidential files to `.gitignore`.
- [ ] Prefer properly configured Docker secrets for confidential values.

## Required Documentation

- [ ] Write `README.md` in English.
- [ ] Make the README first line italicized and exactly state that the project was created as part of the 42 curriculum by the relevant login(s).
- [ ] Include a `Description` section with the goal and a brief overview.
- [ ] Explain the use of Docker, included sources, and the main design choices.
- [ ] Compare virtual machines with Docker.
- [ ] Compare secrets with environment variables.
- [ ] Compare Docker networks with host networking.
- [ ] Compare Docker volumes with bind mounts.
- [ ] Include an `Instructions` section with relevant build, installation, and execution details.
- [ ] Include a `Resources` section with conventional references and an explanation of AI use, including tasks and project parts.

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
