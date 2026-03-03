# WiFi Kinect – Passive RF Sensing with Commodity WiFi

Goal: Build a low-cost, privacy-friendly alternative to Xbox Kinect using only WiFi router signals  
(Detect presence, motion, basic gestures without cameras)

## Current Status (March 2026)

- RSSI-based motion detection working (very coarse)
- Hardware path decided: Raspberry Pi 4/5 + Nexmon CSI firmware
- Software stack: Python + numpy/scipy + scapy

## Hardware Requirements

Recommended (best price/performance in 2026):
- Raspberry Pi 5 (or Pi 4)
- Good WiFi chip supporting monitor mode + CSI extraction:
  - Built-in BCM2712 (with Nexmon patch)
  - OR external Intel AX210 USB adapter + patched driver

Fallback (easier but lower resolution):
- Any Linux laptop + built-in Intel WiFi card

## Quick Start – RSSI Motion Detection

```bash
git clone https://github.com/yourname/wifi-kinect.git
cd wifi-kinect
./setup-wifi-sensing.sh
sudo ./rssi_monitor.py --interface wlan0 --bssid YOUR_ROUTER_BSSID --threshold 8
