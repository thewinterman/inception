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

file_env MARIADB_DATABASE
file_env MARIADB_USER
file_env MARIADB_PASSWORD
file_env MARIADB_ROOT_PASSWORD

: "${MARIADB_DATABASE:?MARIADB_DATABASE must be set}"
: "${MARIADB_USER:?MARIADB_USER must be set}"
: "${MARIADB_PASSWORD:?MARIADB_PASSWORD must be set}"
: "${MARIADB_ROOT_PASSWORD:?MARIADB_ROOT_PASSWORD must be set}"

DATADIR=/var/lib/mysql
SOCKET=/run/mysqld/mysqld.sock

sql_literal() {
    printf '%s' "$1" | sed "s/'/''/g"
}

sql_identifier() {
    printf '%s' "$1" | sed 's/`/``/g'
}

if [ ! -d "$DATADIR/mysql" ]; then
    chown -R mysql:mysql "$DATADIR" /run/mysqld
    mariadb-install-db --user=mysql --datadir="$DATADIR" --auth-root-authentication-method=normal

    mariadbd --user=mysql --skip-networking --socket="$SOCKET" &
    bootstrap_pid=$!
    trap 'kill "$bootstrap_pid" 2>/dev/null || true' EXIT

    ready=false
    for attempt in $(seq 1 30); do
        if mariadb-admin --socket="$SOCKET" ping --silent; then
            ready=true
            break
        fi
        sleep 1
    done
    "$ready" || { echo "MariaDB did not start during initialization" >&2; exit 1; }

    database=$(sql_identifier "$MARIADB_DATABASE")
    user=$(sql_literal "$MARIADB_USER")
    password=$(sql_literal "$MARIADB_PASSWORD")
    root_password=$(sql_literal "$MARIADB_ROOT_PASSWORD")

    mariadb --socket="$SOCKET" -uroot <<-EOSQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${root_password}';
		CREATE DATABASE IF NOT EXISTS \`${database}\`;
		CREATE USER IF NOT EXISTS '${user}'@'%' IDENTIFIED BY '${password}';
		GRANT ALL PRIVILEGES ON \`${database}\`.* TO '${user}'@'%';
		FLUSH PRIVILEGES;
EOSQL

    mariadb-admin --socket="$SOCKET" -uroot --password="$MARIADB_ROOT_PASSWORD" shutdown
    wait "$bootstrap_pid"
    trap - EXIT
fi

exec "$@"
