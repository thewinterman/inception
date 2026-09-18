#!/bin/sh
set -eu

file_env() {
    variable="$1"
    file_variable="${variable}_FILE"
    eval value="\${${variable}:-}"
    eval file_value="\${${file_variable}:-}"

    if [ -n "$value" ] && [ -n "$file_value" ]; then
        echo "Only one of $variable or $file_variable may be set" >&2
        exit 1
    fi

    if [ -n "$file_value" ]; then
        [ -r "$file_value" ] || { echo "Cannot read $file_variable: $file_value" >&2; exit 1; }
        value=$(cat "$file_value")
    fi

    export "$variable=$value"
    unset "$file_variable"
}

file_env WORDPRESS_DB_NAME
file_env WORDPRESS_DB_USER
file_env WORDPRESS_DB_PASSWORD
file_env WORDPRESS_ADMIN_PASSWORD
file_env WORDPRESS_USER_PASSWORD

: "${WORDPRESS_DB_HOST:=mariadb:3306}"
: "${WORDPRESS_DB_NAME:?WORDPRESS_DB_NAME must be set}"
: "${WORDPRESS_DB_USER:?WORDPRESS_DB_USER must be set}"
: "${WORDPRESS_DB_PASSWORD:?WORDPRESS_DB_PASSWORD must be set}"
: "${WORDPRESS_URL:?WORDPRESS_URL must be set}"
: "${WORDPRESS_TITLE:?WORDPRESS_TITLE must be set}"
: "${WORDPRESS_ADMIN_USER:?WORDPRESS_ADMIN_USER must be set}"
: "${WORDPRESS_ADMIN_PASSWORD:?WORDPRESS_ADMIN_PASSWORD must be set}"
: "${WORDPRESS_ADMIN_EMAIL:?WORDPRESS_ADMIN_EMAIL must be set}"
: "${WORDPRESS_USER:?WORDPRESS_USER must be set}"
: "${WORDPRESS_USER_PASSWORD:?WORDPRESS_USER_PASSWORD must be set}"
: "${WORDPRESS_USER_EMAIL:?WORDPRESS_USER_EMAIL must be set}"

case "$(printf '%s' "$WORDPRESS_ADMIN_USER" | tr '[:upper:]' '[:lower:]')" in
    *admin*|*administrator*)
        echo "WORDPRESS_ADMIN_USER must not contain admin or administrator" >&2
        exit 1
        ;;
esac

if [ ! -f /var/www/html/wp-includes/version.php ]; then
    cp -a /usr/src/wordpress/. /var/www/html/
fi

chown -R www-data:www-data /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create --allow-root --path=/var/www/html \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST"
fi

if ! wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
    database_ready=false
    for attempt in $(seq 1 30); do
        if wp db check --allow-root --path=/var/www/html >/dev/null 2>&1; then
            database_ready=true
            break
        fi
        sleep 1
    done
    if ! "$database_ready"; then
        echo "WordPress could not connect to MariaDB after 30 seconds" >&2
        wp db check --allow-root --path=/var/www/html >&2 || true
        exit 1
    fi

    wp core install --allow-root --path=/var/www/html \
        --url="$WORDPRESS_URL" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email
fi

if ! wp user get "$WORDPRESS_USER" --allow-root --path=/var/www/html >/dev/null 2>&1; then
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
        --allow-root --path=/var/www/html \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --role=author
fi

exec "$@"
