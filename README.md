# ISIS3510-GN47

# InteractiveMapUniandes

Smart campus navigation app for Universidad de los Andes.  
Helps students move efficiently using routing, real-time location, and contextual features.

---

## Overview

InteractiveMapUniandes is a mobile application built in **Kotlin (Android)** that integrates:

- Real-time map navigation (Google Maps)
- Backend routing (Flask + Dijkstra)
- QR-based navigation triggers
- Context-aware features
- Firebase authentication

---

## Main Features

### Interactive Map
- Google Maps integration
- Route visualization with polylines
- Camera movement and markers

### Location Sensor
- Uses device GPS
- Detects current position
- Centers map dynamically

### Routing System
- Connects to backend API
- Computes optimal paths (Dijkstra)
- Displays:
  - Route path
  - Estimated time
  - Step-by-step nodes

### QR Code Scanner
- Scan QR to generate routes instantly
- Example:
