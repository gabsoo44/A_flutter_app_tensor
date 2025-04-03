# Temperature & Humidity Sensor Simulation App

This Flutter application simulates a temperature and humidity sensor system, allowing users to:

- Manually input telemetry data
- Simulate automatic data generation
- Visualize data on a dynamic chart
- Switch between active and sleep modes

---

## Project Structure

```text
lib/
├─ models/                 # Data models (e.g., TelemetryPoint)
├─ services/              # Business logic (AutoModeService, ManualModeService, simulators)
├─ screens/               # App screens (UI): Auto, Manual, Home
├─ widgets/               # Reusable UI components (e.g., TelemetryChart)
├─ constants/             # App-wide constants (durations, limits...)
├─ router.dart            # GoRouter configuration
├─ my_app.dart            # Root app configuration
└─ main.dart              # App entry point
```

---

## Features

- 🧪 Manual mode with user-entered telemetry values
- 🔄 Auto mode with simulated periodic data
- 🧭 GoRouter-based navigation system
- 📊 Real-time telemetry chart with fl_chart
- ⚙️ Fake server polling for temperature unit

---

## Next Steps (optional improvements)

- ✅ Add unit/widget tests
- 🌐 Replace FakeServer with real HTTP/WebSocket
- 🧠 Introduce viewmodels or controllers for more scalable state
- ☁️ Integrate cloud storage or database

---

## Dependencies

- `go_router`
- `fl_chart`
- `flutter` SDK

---

## Author

Gabriel Guillore — 2025
