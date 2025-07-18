set -e

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

echo "allow-loopback-pinentry" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent

export GPG_TTY=$(tty)
echo "$GPG_PRIVATE_KEY" | gpg --batch --yes --pinentry-mode loopback --passphrase "$GPG_PASSPHRASE" --import
git-crypt add-gpg-user D0AFDA5AABAEE754
git-crypt unlock