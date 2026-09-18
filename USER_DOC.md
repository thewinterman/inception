# User Documentation

## Services

The website is a WordPress installation served securely through NGINX. NGINX accepts HTTPS connections on port `443`. WordPress runs the site and administration panel; MariaDB stores site content, accounts, and settings. WordPress and MariaDB are private and cannot be reached directly from the host.

## Start and Stop

From the repository root, start the stack with:

```sh
make
```

Stop the containers while keeping website and database data:

```sh
make down
```

Restart all services:

```sh
make restart
```

## Access

Open `https://<login>.42.fr` in a browser. The certificate is self-signed, so the browser will display a certificate warning during local development; continue only after confirming the displayed domain is the configured local domain.

The WordPress administration panel is available at:

```text
https://<login>.42.fr/wp-admin/
```

Replace `<login>` with the value configured in `srcs/.env`. The domain must resolve locally, for example through this `/etc/hosts` entry:

```text
127.0.0.1 <login>.42.fr
```

## Credentials

Credentials are stored as one-line files in the ignored `secrets/` directory. The WordPress administrator username is configured as `WORDPRESS_ADMIN_USER` in `srcs/.env`; its password is in `secrets/wordpress_admin_password.txt`.

Do not commit, share, or put secret values in `srcs/.env`. To change a password after WordPress has already been installed, use the WordPress administration panel or WP-CLI inside the WordPress container. Changing the secret file alone does not update an existing WordPress account.

## Verify Services

Show service status:

```sh
make ps
```

Follow the service logs:

```sh
make logs
```

All three services should be running. Then confirm that the homepage and `/wp-admin/` load through HTTPS.
