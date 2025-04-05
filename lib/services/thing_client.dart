import 'dart:async';
import 'dart:io';

class ThingClient {
  final String thingId = "flutter_app_tensor_01"; 
  WebSocket? _socket;
  final StreamController<String> _controller = StreamController.broadcast();

  Stream<String> get messages => _controller.stream;

  // ignore: public_member_api_docs
  Future<void> connectToWebSocket(String url) async {
    _socket = await WebSocket.connect(url);
    _socket!.listen(
      (msg) => _controller.add(msg as String),
      onError: (err) => print("Erreur WebSocket : $err"),
      onDone: () => print('Connexion WebSocket fermée'),
    );
  }


  void sendMessage(String msg) {
    _socket?.add(msg);
  }

  void closeConnection() {
    _socket?.close();
    _controller.close();
  }

  bool get isConnected => _socket != null;
}
