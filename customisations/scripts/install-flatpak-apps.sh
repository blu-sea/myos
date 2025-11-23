#!/bin/bash
cat ./flatpak-apps | xargs flatpak install --user flathub -y  
