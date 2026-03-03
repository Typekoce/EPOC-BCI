#!/usr/bin/env python3
"""
Simple RSSI-based WiFi motion / presence detector
- Scans nearby access points every few seconds
- Looks for significant RSSI fluctuations on your chosen router
- Useful as a very basic "someone is moving nearby" trigger
"""

import subprocess
import re
import time
import argparse
from datetime import datetime
from collections import deque

def parse_iwlist_scan(interface="wlan0"):
    """Run iwlist scan and extract BSSIDs + RSSI"""
    try:
        output = subprocess.check_output(
            ["sudo", "iwlist", interface, "scan"],
            stderr=subprocess.STDOUT,
            text=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Error scanning: {e.output}")
        return {}

    aps = {}
    current_bssid = None
    for line in output.splitlines():
        line = line.strip()
        if "Address:" in line:
            current_bssid = line.split("Address: ")[1].strip()
        elif "Signal level=" in line and current_bssid:
            match = re.search(r"Signal level=([-]?\d+) dBm", line)
            if match:
                rssi = int(match.group(1))
                aps[current_bssid] = rssi
    return aps

def main():
    parser = argparse.ArgumentParser(description="Simple WiFi RSSI motion monitor")
    parser.add_argument("--interface", default="wlan0", help="WiFi interface (default: wlan0)")
    parser.add_argument("--bssid", required=True, help="Target router BSSID (e.g. AA:BB:CC:DD:EE:FF)")
    parser.add_argument("--threshold", type=int, default=8, help="RSSI change threshold for motion (dB)")
    parser.add_argument("--window", type=int, default=10, help="Sliding window size (samples)")
    args = parser.parse_args()

    print(f"Monitoring BSSID {args.bssid} on {args.interface}")
    print(f"Motion alert if RSSI changes > {args.threshold} dB in {args.window} samples")
    print("-" * 60)

    history = deque(maxlen=args.window)
    last_alert = 0

    while True:
        aps = parse_iwlist_scan(args.interface)
        current_rssi = aps.get(args.bssid)

        if current_rssi is None:
            print(f"[{datetime.now():%Y-%m-%d %H:%M:%S}] Router not found")
        else:
            history.append(current_rssi)
            print(f"[{datetime.now():%Y-%m-%d %H:%M:%S}] RSSI: {current_rssi} dBm   (samples: {len(history)})")

            if len(history) >= args.window:
                min_rssi = min(history)
                max_rssi = max(history)
                delta = max_rssi - min_rssi

                if delta >= args.threshold and (time.time() - last_alert > 30):
                    print(f"!!! MOTION DETECTED !!! Delta: {delta} dB")
                    last_alert = time.time()

        time.sleep(3)  # scan interval

if __name__ == "__main__":
    main()
