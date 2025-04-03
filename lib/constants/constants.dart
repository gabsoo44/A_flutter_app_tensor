// Temperature intervals depending on mode
const Duration kTempIntervalActive = Duration(seconds: 10);
const Duration kTempIntervalSleep = Duration(seconds: 20);

// Humidity intervals depending on mode
const Duration kHumIntervalActive = Duration(seconds: 20);
const Duration kHumIntervalSleep = Duration(seconds: 50);

// Server polling intervals depending on mode
const Duration kPollingIntervalActive = Duration(seconds: 10);
const Duration kPollingIntervalSleep = Duration(seconds: 20);

// Max number of telemetry points to keep on chart
const int kMaxTelemetryPoints = 20;
