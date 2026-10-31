#!/bin/bash

set -ouex pipefail

### Install packages

################# myOS ####################
# Nix Store, at least create the /nix folder, whether it gets used much or not
mkdir -p /nix
#################
# Epson drivers
# Stage the driver which will install to /opt in /usr since it's final destination in /var/opt is persistent with previous user files on all but the first deployment, then deploy to /var/opt on first boot after update

# 1. Install into a real /opt so the RPM is happy
if [ -L /opt ]; then
  rm /opt
fi
mkdir -p /opt
dnf5 install -y /ctx/bin/epson-inkjet-printer-escpr2-1.2.44-1.x86_64.rpm

# 2. Copy Epson driver and deploy script to an immutable staging path (survives in /usr, updated every upgrade)
mkdir -p /usr/lib/epson-escpr2
cp -a /opt/epson-inkjet-printer-escpr2/. /usr/lib/epson-escpr2/
cp -a /ctx/scripts/deploy-epson.sh /usr/lib/epson-escpr2/
chmod +x /usr/lib/epson-escpr2/deploy-epson.sh
cp -a /ctx/systemd/epson-escpr2-deploy.service /etc/systemd/system/
ln -sf /etc/systemd/system/epson-escpr2-deploy.service /etc/systemd/system/multi-user.target.wants/epson-escpr2-deploy.service

# 3. Remove real /opt, restore the symlink
rm -rf /opt
ln -s /var/opt /opt
# Epson driver: put its /opt payload in the image, not /var/opt
# If symlinked then delete symlink and create hard /opt
#if [ -L /opt ]; then
#  rm /opt
#fi 
#mkdir -p /opt
# Install the driver
#dnf5 install -y /ctx/bin/epson-inkjet-printer-escpr2-1.2.44-1.x86_64.rpm
# Copy the /opt installation to /var/opt
#cp -a /opt/. /var/opt/
# Remove the hard /opt directory
#rm -rf /opt
# Symlink it back
#ln -s /var/opt /opt   

# this installs a package from fedora repos
dnf5 install -y tmux mc konsole plocate 

# VPN this is a quick hack local rpm install, TODO - make the repo work instead so this rpm updates automatically
dnf5 install -y /ctx/bin/nordvpn-4.2.3-1.x86_64.rpm
#############################################

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Teamviewer
#dnf5 install -y /ctx/bin/teamviewerXXXX.rpm

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package

# Onedriver
# Currently broken due dependecies, so disabled
#dnf5 -y copr enable jstaf/onedriver
#dnf5 -y install onedriver

# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
#

# Add Netbird attempt .... ?
# Add the reop first. 
#tee /etc/yum.repos.d/netbird.repo <<EOF
#[netbird]
#name=netbird
#baseurl=https://pkgs.netbird.io/yum/
#enabled=1
#gpgcheck=0
#gpgkey=https://pkgs.netbird.io/yum/repodata/repomd.xml.key
#repo_gpgcheck=0
#EOF

#dnf5 -y config-manager addrepo --from-repofile=/etc/yum.repos.d/netbird.repo
#dnf5 -y install netbird

#### Enable Systemd Unit Files

systemctl enable podman.socket
systemctl enable nordvpnd
