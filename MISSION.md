# Mission Statement – EPOC-BCI Project

**Vision**  
Build an accessible, consumer-grade multi-modal sensing platform that dramatically improves **data integrity** and reliability by cross-referencing signals from multiple everyday devices. Instead of relying on any single sensor (which can be noisy, occluded, or biased), we let devices **validate each other** in real time — creating a more robust picture of human state, intent, movement, and environment.

**Core Principle**  
Every affordable, over-the-counter device should help verify and enrich the others. No exotic lab equipment. No six-figure budgets. Just hardware the average person can realistically purchase and set up at home.

**Stage 1 – Device Constellation**  
List and integrate the following consumer-grade devices as cross-checking sensors:

- **Emotiv EPOC (Model 1.1)** — Primary EEG/brain interface (neural signals, focus, engagement, mental commands)
- **Meta Quest Pro** — VR headset with eye tracking, hand tracking, head pose, IMU, depth sensing
- **Apple Vision Pro** — Spatial computing with high-res eye tracking, hand/body tracking, LiDAR, IMU, neural engine
- **Xbox Kinect** (v1 or v2) — Depth camera, RGB camera, skeletal tracking, voice (legacy motion-capture powerhouse, still available used/refurb)
- **Any domestic Wi-Fi router** — Passive RF-based sensing (CSI / Wi-Fi sensing for motion, presence, breathing, coarse gesture detection through walls — emerging consumer tech from Xfinity, origin, etc.)
- **Nintendo Switch** — IMU (gyro/accel in Joy-Cons), IR camera (in some models), handheld/portable motion input

Goal: Achieve **mutual cross-validation**.  
Examples:
- Emotiv mental "push" command → confirmed by Quest hand movement + Kinect skeletal arm extension + Wi-Fi motion blob in that direction.
- User focus detected by Emotiv → validated by steady gaze (Vision Pro eye tracking) + low hand jitter (Quest/kinect IMU).
- Presence/motion detected via Wi-Fi CSI → correlated with Kinect depth map or Switch controller wake-up.

**Stage 2 – Interfacing & Fusion**  
- Develop clean, modular interfaces for each device (building on current Emotiv Cortex work).
- Create a central data-fusion layer (e.g., Python + Lab Streaming Layer / ROS2 / custom WebSocket bus).
- Synchronize timestamps across devices.
- Implement cross-check rules / confidence scoring (e.g., "high integrity" when ≥3 devices agree within tolerance).
- Handle missing devices gracefully (progressive enhancement).

**Stage 3 – Demo Game / Experience**  
Build a single, compelling proof-of-concept application (game or interactive experience) that:
- Requires input from **multiple** devices simultaneously.
- Demonstrates improved reliability / novel interaction thanks to cross-verification.
- Runs on consumer hardware (Ubuntu PC as hub + connected devices).
- Possible concepts: neuro-driven adventure game, collaborative VR puzzle, accessibility-focused controller, "mind + body" fitness trainer, or presence-aware smart-home game.

**Guiding Values**
- Accessibility first — keep costs under ~$2,000–3,000 total for a full setup.
- Privacy & ethics — local processing only where possible; transparent data handling.
- Open source where feasible — share interfaces, fusion logic, and demo code.
- Fun & curiosity-driven — this should feel like sci-fi made real with stuff you can buy today.

This mission will evolve — feedback and discoveries welcome!