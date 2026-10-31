#!/usr/bin/env bash

# Blu-sea script to deploy the Epson driver from the staging area to /var/opt
# /usr/lib/epson-escpr2/deploy-epson.sh

set -euo pipefail

SRC=/usr/lib/epson-escpr2
DEST=/var/opt/epson-inkjet-printer-escpr2
STAMP="$DEST/.deployed-version"

# Read the version we want (from the RPM's own version file or a stamp we write at build)
WANT="1.2.44-1"

# Skip if already deployed at this version
if [ -f "$STAMP" ] && [ "$(cat "$STAMP")" = "$WANT" ]; then
    exit 0
fi

mkdir -p "$DEST"
cp -a "$SRC"/. "$DEST"/
echo "$WANT" > "$STAMP"
