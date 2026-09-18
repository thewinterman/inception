# Secret Templates

Copy this directory to `../secrets` from the `srcs` directory, or create the files listed below in the repository-root `secrets/` directory. Replace each placeholder with one value and keep every file to a single line without surrounding quotes.

```sh
cp -r secrets.template secrets
```

`secrets/` is ignored by Git. Docker Compose mounts these files at `/run/secrets/<secret_name>`.

| File | Purpose |
| --- | --- |
| `mariadb_database.txt` | WordPress database name |
| `mariadb_user.txt` | MariaDB account used by WordPress |
| `mariadb_password.txt` | Password for the WordPress database account |
| `mariadb_root_password.txt` | MariaDB root password |
| `wordpress_admin_password.txt` | WordPress administrator password |
| `wordpress_user_password.txt` | Password for the additional WordPress user |
