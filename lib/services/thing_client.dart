import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Client responsible for managing WebSocket communication with the server.
///
/// This class handles connection setup, message transmission, and message
/// reception via a stream controller. It abstracts all networking logic from the UI.
class ThingClient {
  /// Unique identifier for the "thing" (sensor device).
  final String thingId = "flutter_app_tensor_01";

  /// WebSocket channel used for bidirectional communication.
  WebSocketChannel? _channel;

  /// Stream controller to broadcast received messages.
  final StreamController<String> _controller = StreamController.broadcast();

  /// Public stream of incoming messages from the WebSocket.
  Stream<String> get messages => _controller.stream;

  /// Attempts to establish a WebSocket connection to the given URL.
  ///
  /// If the connection is successful, it listens to incoming messages
  /// and pushes them into the [messages] stream.
  Future<void> connectToWebSocket(String url) async {
    print("Tentative de connexion à $url...");

    try {
      // Try to open a WebSocket connection
      _channel = WebSocketChannel.connect(Uri.parse(url));
      print("Connexion WebSocket réussie");

      // Listen to incoming messages from the server
      _channel!.stream.listen(
        (msg) {
          print("Reçu du serveur : $msg");
          _controller.add(msg as String); // Broadcast the message
        },
        onError: (err) {
          print("Erreur WebSocket : $err");
        },
        onDone: () {
          print("Connexion WebSocket fermée");
        },
      );
    } catch (e) {
      print("Impossible de se connecter au WebSocket : $e");
    }
  }

  /// Sends a message to the WebSocket server if connected.
  ///
  /// The message must be a JSON-encoded string (already prepared).
  void sendMessage(String msg) {
    if (isConnected) {
      _channel?.sink.add(msg);
      print("📤Message envoyé : $msg");
    } else {
      print("Socket non connectée. Impossible d'envoyer le message.");
    }
  }

  /// Closes the WebSocket connection and cleans up resources.
  void closeConnection() {
    _channel?.sink.close();
    _controller.close();
  }

  /// Returns true if the WebSocket connection is currently open.
  bool get isConnected => _channel != null;
}
