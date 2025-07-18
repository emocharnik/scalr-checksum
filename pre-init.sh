#!/bin/bash
set -e

cd ../

# Validate required environment variables
if [ -z "$GPG_PASSPHRASE" ]; then
    echo "Error: GPG_PASSPHRASE environment variable is required"
    exit 1
fi

if [ -z "$GPG_PRIVATE_KEY" ]; then
    echo "Error: GPG_PRIVATE_KEY environment variable is required"
    exit 1
fi

if [ -z "$GPG_KEY_ID" ]; then
    echo "Error: GPG_KEY_ID environment variable is required"
    exit 1
fi

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# Configure GPG for non-interactive use with long cache timeout
cat << EOF >> ~/.gnupg/gpg-agent.conf
allow-loopback-pinentry
default-cache-ttl 86400
max-cache-ttl 86400
EOF

cat << EOF >> ~/.gnupg/gpg.conf
pinentry-mode loopback
batch
yes
EOF

gpgconf --kill gpg-agent
gpgconf --launch gpg-agent

export GPG_TTY=$(tty)

# Import the GPG key from environment variable
echo "Importing GPG key: $GPG_KEY_ID"
echo "$GPG_PRIVATE_KEY" | gpg --batch --yes --pinentry-mode loopback --passphrase "$GPG_PASSPHRASE" --import

# Test the key by signing something to cache the passphrase
echo "Caching passphrase for key: $GPG_KEY_ID"
echo "test" | gpg --batch --yes --pinentry-mode loopback --passphrase "$GPG_PASSPHRASE" --sign --armor --local-user "$GPG_KEY_ID" > /dev/null

echo "Unlocking git-crypt repository..."
git-crypt unlock

echo "Repository decrypted successfully!"
cd -
