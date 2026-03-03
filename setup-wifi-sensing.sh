#!/usr/bin/env bash
# setup-wifi-sensing.sh - Install tools for WiFi RF sensing (Kinect-like gesture/motion detection using router signals)
# Goal: Build a passive radar system using Channel State Information (CSI) or RSSI

echo "=============================================================="
echo " WiFi Kinect Setup (RF sensing with router signals)"
echo "=============================================================="

sudo apt update && sudo apt upgrade -y

echo "Installing core Wi-Fi & analysis tools..."
sudo apt install -y \
    iw wireless-tools tcpdump tshark wireshark-common \
    build-essential git cmake make \
    python3 python3-pip python3-venv \
    libpcap-dev rtl-sdr librtlsdr-dev

echo "Installing Python packages for signal processing..."
python3 -m pip install --upgrade pip
python3 -m pip install numpy scipy matplotlib pandas scapy plotly scikit-learn seaborn

echo "Creating project folder..."
mkdir -p ~/wifi-kinect/tools
cd ~/wifi-kinect/tools

echo "Cloning useful open-source CSI projects..."
git clone https://github.com/zeroby0/nexmon_csi.git 2>/dev/null || echo "nexmon_csi already exists"
git clone https://github.com/xyang35/wifi-csi-sensing.git 2>/dev/null || echo "wifi-csi-sensing already exists"

echo ""
echo "=============================================================="
echo "✅ Installation finished!"
echo ""
echo "IMPORTANT REALITY CHECK for your Kinect-like project:"
echo "• True high-resolution gesture tracking (like Xbox Kinect) needs raw CSI data."
echo "• Normal routers usually don't expose it — you need special hardware:"
echo "   - Raspberry Pi 4/5 + nexmon_csi firmware (easiest & cheapest)"
echo "   - Intel 5300 NIC with patched driver (classic research choice)"
echo "   - Intel AX200/AX210 with custom kernel module"
echo ""
echo "Recommended next steps:"
echo "   cd ~/wifi-kinect"
echo "   Study nexmon_csi repo (best starting point)"
echo "   Start with simple RSSI-based motion detection (easier than full CSI)"
echo "   Then move to CSI once you have the right hardware"
echo "=============================================================="
