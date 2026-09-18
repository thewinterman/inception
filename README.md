*This project has been created as part of the 42 curriculum by <login>.*

# Inception

## Description

Inception is a small WordPress infrastructure deployed with Docker Compose. Its goal is to run a secure, persistent web stack made from locally built images rather than prebuilt service images.

The stack contains three dedicated Debian 12 containers:

- **NGINX** is the only public entrypoint. It exposes port `443`, generates a development TLS certificate, allows TLS 1.2 and TLS 1.3 only, and forwards PHP requests to WordPress.
- **WordPress** runs PHP-FPM on the internal network. Its entrypoint installs WordPress and creates an administrator and an additional author account on first startup.
- **MariaDB** initializes the WordPress database and its database account on first startup.

Each image is built from its Dockerfile under `srcs/requirements/`. Docker Compose connects the services through a private bridge network. MariaDB data and WordPress files use named volumes whose host locations are configured in `srcs/.env`.

### Design Choices

Docker packages the service, its dependencies, and runtime configuration into reproducible containers. Compose declares the relationships between those containers, their network, secrets, and persistent storage in one file. NGINX is intentionally separate from WordPress so it is the sole HTTPS-facing service; MariaDB is not exposed on the host.

Sensitive values are supplied as Compose secrets and mounted at `/run/secrets/`. Non-sensitive settings, including the domain name and persistent-data paths, are supplied through `srcs/.env`.

### Comparisons

| Topic | Choice in this project | Alternative |
| --- | --- | --- |
| Virtual machines vs Docker | Containers share the host kernel, start quickly, and package only each service's userspace dependencies. | Virtual machines emulate a complete operating system with their own kernel, which provides stronger isolation but uses more resources. |
| Secrets vs environment variables | Secrets are separate files mounted at runtime and are not embedded in image layers or normally displayed in container metadata. | Environment variables are convenient for non-sensitive configuration but can leak through inspection tools, logs, or process environments. |
| Docker network vs host network | The `inception` bridge network gives services private DNS names such as `mariadb` and `wordpress`; only NGINX publishes a host port. | Host networking removes this isolation and exposes services directly on the host network stack. |
| Docker volumes vs bind mounts | Named volumes are managed by Docker while their local-driver locations are explicitly configured below `/home/<login>/data`. | Bind mounts directly map arbitrary host paths into containers and couple the stack more tightly to host filesystem layout and permissions. |

## Instructions

### Prerequisites

Use a Debian virtual machine with Docker Engine and the Docker Compose plugin. The Makefile can install them from Docker's official Debian repository:

```sh
make install-deps
make docker-group
```

After `make docker-group`, log out and back in so Docker can be used without `sudo`.

Add the project domain to `/etc/hosts`, replacing the login as appropriate:

```text
127.0.0.1 <login>.42.fr
```

### Configuration

Create the non-sensitive environment file and replace every `<login>` placeholder:

```sh
cp srcs/.env.template srcs/.env
```

Create the local secrets directory from its template, then replace every placeholder with a one-line value:

```sh
cp -r secrets.template secrets
```

The required secret files are:

```text
secrets/mariadb_database.txt
secrets/mariadb_user.txt
secrets/mariadb_password.txt
secrets/mariadb_root_password.txt
secrets/wordpress_admin_password.txt
secrets/wordpress_user_password.txt
```

Do not commit `srcs/.env` or `secrets/`. Both are excluded by `.gitignore`.

### Run

```sh
make
```

This validates the configuration and secrets, creates the configured persistent-data directories, builds each image, and starts the stack in the background. Visit `https://<login>.42.fr`; the WordPress administration panel is at `https://<login>.42.fr/wp-admin/`.

Useful commands:

```sh
make ps       # Show service status
make logs     # Follow all service logs
make down     # Stop containers and preserve data
make clean    # Remove containers, images, and named volumes
make restart  # Recreate the running stack
```

## Resources

- [Docker Engine installation for Debian](https://docs.docker.com/engine/install/debian/)
- [Docker Compose reference](https://docs.docker.com/reference/compose-file/)
- [Docker secrets](https://docs.docker.com/compose/how-tos/use-secrets/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress developer documentation](https://developer.wordpress.org/)
- [WP-CLI documentation](https://wp-cli.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)

AI was used to help draft the Dockerfiles, service entrypoints, Compose configuration, Makefile, and project documentation. The resulting configuration was reviewed and adapted for this project; it still requires validation on the target virtual machine.
