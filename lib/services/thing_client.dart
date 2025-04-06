import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class ThingClient {
  final String thingId = "flutter_app_tensor_01";
  WebSocketChannel? _channel;
  final StreamController<String> _controller = StreamController.broadcast();

  Stream<String> get messages => _controller.stream;

  Future<void> connectToWebSocket(String url) async {
    print("Tentative de connexion à $url...");
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      print("Connexion WebSocket réussie");

      _channel!.stream.listen(
        (msg) {
          print("Reçu du serveur : $msg");
          _controller.add(msg as String);
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

  void sendMessage(String msg) {
    if (isConnected) {
      _channel?.sink.add(msg);
      print("📤Message envoyé : $msg");
    } else {
      print("Socket non connectée. Impossible d'envoyer le message.");
    }
  }

  void closeConnection() {
    _channel?.sink.close();
    _controller.close();
  }

  bool get isConnected => _channel != null;
}
