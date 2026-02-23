# Emotiv Old EPOC BCI Interface for Ubuntu

## Mission & Vision
→ Read the full [MISSION.md](./MISSION.md) for the long-term goal of this project.

This repository provides scripts and installation helpers to interface with an old **Emotiv EPOC** (or similar legacy models) EEG brain-computer interface headset on Ubuntu Linux.

**Important (February 2026 update):**  
The original Emotiv EPOC is a legacy device (~2009–2014). Official support now focuses on newer headsets (EPOC+, EPOC X, Insight, etc.) via the **Cortex API**. Linux support for Cortex/Emotiv Launcher is in **beta** for Ubuntu 22.04+ (64-bit only).  

Two paths are available:

1. **python-emotiv** library — reverse-engineered, lightweight, no launcher needed. **Unmaintained/archived since 2025** — use as fallback for old EPOC if Cortex fails to detect your headset.
2. **Cortex API** (WebSocket) — official modern path. Requires Emotiv Launcher/Cortex service running. Preferred if your headset is detected.

## Features

- Automated installation for dependencies and python-emotiv (legacy)
- Basic real-time EEG streaming example via Cortex API
- Raw sensor values with timestamps
- Easy extension for logging, analysis (NumPy/SciPy), or BCI experiments

## Requirements

- Ubuntu 22.04 / 24.04 LTS (64-bit recommended; 20.04 may work for legacy path)
- Old Emotiv EPOC headset + USB dongle (Bluetooth unreliable in legacy mode)
- Python 3.8+
- For Cortex path: Emotiv account + registered Cortex app (`client_id` / `client_secret`)

## Files in this repository

- `install-emotiv-bci.sh`  
  Installs system packages, Python dependencies, clones & installs python-emotiv (legacy), sets up udev rules (if available), and reports what's installed + any running services/processes.

- `emotiv_interface.py`  
  Example Python script using the official **Cortex API** (WebSocket-based).  
  Connects → authorizes → creates session → subscribes to raw EEG → prints live data.  
  Requires Emotiv Launcher / Cortex service running.

## Installation (Recommended: Cortex API Path for Modern Compatibility)

1. Download and install **Emotiv Launcher** for Linux (Beta) from:  
   https://www.emotiv.com/products/emotiv-launcher#download  
   → Select the **Ubuntu Beta** version (for 22.04+).  
   Run the installer, launch it, log in with your Emotiv account, and connect your headset (via USB dongle). It should detect and pair if compatible.

2. Register a free Cortex app here:  
   https://www.emotiv.com/my-account/applications/  
   → Create a new app to get your `client_id` and `client_secret`.

3. Edit `emotiv_interface.py` and insert your credentials:
   ```python
   client_id = 'your_client_id'
   client_secret = 'your_client_secret'