# Developer Documentation

## Prerequisites

Develop on a Debian virtual machine. Install Docker Engine, Buildx, and the Docker Compose plugin using the official Docker APT repository procedure encoded in the Makefile:

```sh
make install-deps
make docker-group
```

Log out and back in after `make docker-group`. Confirm the installation with:

```sh
docker version
docker compose version
```

### Manual Dependency Installation

To install the same dependencies manually on Debian, first remove conflicting distribution packages when they are installed:

```sh
sudo apt remove docker.io docker-compose docker-doc docker-buildx podman-docker containerd runc
```

Add Docker's official repository and signing key:

```sh
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

Install Docker Engine and its Compose plugin:

```sh
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"
```

Log out and back in after changing the group, then verify the installation:

```sh
docker version
docker compose version
```

## Configure the Stack

Create the non-sensitive configuration file:

```sh
cp srcs/.env.template srcs/.env
```

Edit `srcs/.env` and set the domain, WordPress metadata, and the two data paths. The data paths must be below `/home/<login>/data`, for example:

```env
MARIADB_DATA_PATH=/home/<login>/data/mariadb
WORDPRESS_DATA_PATH=/home/<login>/data/wordpress
```

Create secret files from the tracked templates:

```sh
cp -r secrets.template secrets
```

Replace every placeholder in `secrets/` with a single-line value. The required files are documented in [secrets.template/README.md](secrets.template/README.md). `srcs/.env` and `secrets/` are ignored by Git; never add actual credential files to version control.

Configure the local domain before starting services:

```text
127.0.0.1 <login>.42.fr
```

Add that line to `/etc/hosts`, replacing `<login>` with the `DOMAIN_NAME` value from `srcs/.env`.

## Build and Launch

```sh
make
```

The default target validates Docker, Compose, `.env`, and secret files; creates both configured data directories; then runs:

```sh
docker compose --env-file srcs/.env -f srcs/docker-compose.yml up --build -d
```

Use `make build` to build without starting. Use `make check` to validate the prerequisites and configuration without building images.

## Operations

```sh
make ps       # Service status
make logs     # Follow service logs
make down     # Stop containers; retain volumes and host data
make restart  # Stop and rebuild/start the stack
make clean    # Remove containers, named volumes, and local images
```

The underlying Compose commands are also available directly:

```sh
docker compose --env-file srcs/.env -f srcs/docker-compose.yml ps
docker compose --env-file srcs/.env -f srcs/docker-compose.yml logs -f
docker volume ls
docker volume inspect mariadb_data wordpress_data
```

## Persistent Data

Compose creates two named volumes using the local driver:

| Volume | Container path | Host path setting |
| --- | --- | --- |
| `mariadb_data` | `/var/lib/mysql` | `MARIADB_DATA_PATH` |
| `wordpress_data` | `/var/www/html` | `WORDPRESS_DATA_PATH` |

The Makefile creates the configured host directories before Compose starts. `make down` preserves both volumes and their data. `make clean` removes the Docker volume definitions but does not delete the underlying configured host directories; remove those directories manually only when a complete data reset is intended.
