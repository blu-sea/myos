#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
#
# Nordvpn
# Install the workaround rpm for nordvpn
# dnf5 install -y /var/tmp/nordvpn-3.18.5-1.x86_64.rpm # I commented this line out because the 'file doesn't exist' - to be debugged

#### Example for enabling a System Unit File

systemctl enable podman.socket
