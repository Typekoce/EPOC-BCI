#!/bin/bash

# install-emotiv-bci.sh
# Script to install software for interfacing with old Emotiv EPOC brain scanner on Ubuntu.
# Installs dependencies, clones and installs python-emotiv library.
# Outputs what has been installed and checks for related services/processes.

set -e  # Exit on error

echo "Starting installation for Emotiv EPOC on Ubuntu..."

# Update package list
sudo apt update

# Install system dependencies
echo "Installing system dependencies..."
sudo apt install -y python3 python3-pip git libusb-1.0-0-dev bluez  # bluez for potential Bluetooth, libusb for USB dongle

# Install Python dependencies
echo "Installing Python dependencies..."
pip3 install --user pyusb pycrypto numpy scipy matplotlib websocket-client  # websocket-client for potential Cortex use

# Clone and install python-emotiv
echo "Cloning and installing python-emotiv..."
git clone https://github.com/ozancaglayan/python-emotiv.git
cd python-emotiv
sudo python3 setup.py install

# Set up udev rules if present (assuming the repo has 99-emotiv.rules)
if [ -f "99-emotiv.rules" ]; then
    echo "Setting up udev rules..."
    sudo cp 99-emotiv.rules /etc/udev/rules.d/
    sudo udevadm control --reload-rules
    sudo udevadm trigger
else
    echo "No udev rules file found in repo. Skipping."
fi

cd ..

# Clean up
rm -rf python-emotiv

# Output what has been installed
echo "Installed system packages:"
apt list --installed | grep -E 'python3|pip|git|libusb|bluez'

echo "Installed Python packages:"
pip3 list | grep -E 'pyusb|pycrypto|numpy|scipy|matplotlib|websocket'

# Check running services
echo "Running services related to Emotiv (likely none, as it's a library):"
systemctl list-units --type=service | grep -i emotiv || echo "No Emotiv-related services found."

# Check running processes
echo "Running processes related to Emotiv (likely none until you run a script):"
ps aux | grep -i emotiv | grep -v grep || echo "No Emotiv-related processes found."

echo "Installation complete. You can now use the python-emotiv library to interface with your EPOC headset."
echo "For Cortex API (if compatible), download Emotiv Launcher manually from https://www.emotiv.com/products/emotiv-launcher#download (Beta for Ubuntu 22.04+)."
