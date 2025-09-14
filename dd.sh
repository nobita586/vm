#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALLER_DIR="$SCRIPT_DIR/installer/packages"
PTERO_ROOT="$SCRIPT_DIR"

echo "[ REVIACTYL INSTALLATION SCRIPT ]"

TARGET_FILE="$INSTALLER_DIR/resources/views/templates/wrapper.blade.php"
if [ -f "$TARGET_FILE" ]; then
    rm -f "$TARGET_FILE"
    echo "Removed old template files."
else
    echo "File not found: $TARGET_FILE (skipping)"
fi

echo "[INFO] Extracting packages..."
for i in {1..7}; do
    ZIP_FILE="$INSTALLER_DIR/$i.zip"
    if [ -f "$ZIP_FILE" ]; then
        echo " - Extracting $ZIP_FILE"
        unzip -o "$ZIP_FILE" -d "$PTERO_ROOT" >/dev/null
    else
        echo "[WARN] $ZIP_FILE not found, skipping."
    fi
done

if [ ! -d "$INSTALLER_DIR" ]; then
    echo "[ERROR] The installer directory is missing. Please ensure you're in the panel root."
    exit 1
fi

read -p "Have you installed all dependencies from README.md file? (y/n): " deps
if [[ "$deps" != "y" && "$deps" != "Y" ]]; then
    echo "Please install dependencies before running."
    exit 1
fi

read -p "Select the name of the user running web server process [www-data/nginx/apache] (default: www-data): " user
user=${user:-www-data}

read -p "Select the group of the user running web server process [www-data/nginx/apache] (default: www-data): " group
group=${group:-www-data}

echo "[ RUNNING REVIX INSTALLER ]"

echo "[INFO] Running migration..."
php artisan migrate --force

echo "[INFO] Installing yarn packages..."
yarn

echo "[INFO] Building panel..."
NODE_VERSION=$(node -v | sed 's/v//')
NODE_MAJOR=$(echo $NODE_VERSION | cut -d. -f1)

if [ "$NODE_MAJOR" -ge 17 ]; then
    export NODE_OPTIONS=--openssl-legacy-provider
fi

yarn build:production --progress

echo "[INFO] Building routes..."
php artisan optimize

echo "[INFO] Fixing web server permissions..."
chown -R $user:$group "$PTERO_ROOT"/*

echo "[SUCCESS] Revix Theme has been installed and is ready to use."
