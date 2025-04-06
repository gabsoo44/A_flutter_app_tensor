import 'dart:io';

/// Entry point of the FakeServer – simulates a WebSocket server 
/// for receiving telemetry data from IoT clients (temperature sensor).
void main() async {
  // Bind the HTTP server to all available IPv4 interfaces on port 5001
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 5001);
  print('FakeServer listening on ws://${server.address.address}:${server.port}');

  // Listen for incoming HTTP requests
  await for (HttpRequest request in server) {
    // Check if the request is a WebSocket upgrade
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      // Upgrade the HTTP request to a WebSocket connection
      final socket = await WebSocketTransformer.upgrade(request);
      print('Client connected');

      // Listen to incoming messages from the client
      socket.listen(
        (message) => print('📩 Received from client: $message'),
        onDone: () => print('Client disconnected'),
        onError: (e) => print('Error: $e'),
      );
    }
  }
}
