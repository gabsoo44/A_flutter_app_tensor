import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class ThingClient {
  final String serverUrl = "http://172.16.144.22:4001";
  final String wsUrl = "ws://172.16.144.22:5001/ws";

  String thingId = "12345";
  String apiKey = "4e404bd18ab5ca3f6a727464f9f51ea9";

  WebSocketChannel? channel;
  bool isSending = false;
  bool isWebSocketConnected = false;
  bool isChannelOpen = false;

  static final ThingClient _instance = ThingClient._internal();
  factory ThingClient() => _instance;
  ThingClient._internal();

  Future<void> connectToWebSocket() async {
    if (isWebSocketConnected) {
      print("⛔ WebSocket déjà connecté, tentative ignorée.");
      return;
    }

    // Fermer proprement s'il y a un ancien canal
    if (channel != null) {
      await channel!.sink.close();
      print("🛑 Ancienne connexion WebSocket fermée avant reconnexion");
    }

    try {
      channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      await channel?.ready;
      isChannelOpen = true;
      isWebSocketConnected = true;

      print("🔗 WebSocket connecté");

      final authMessage = jsonEncode({"id": thingId, "key": apiKey});
      channel?.sink.add(authMessage);
      print("🔑 Authentification envoyée : $authMessage");

      channel!.stream.listen(
        (data) {
          print("📩 Message reçu : $data");

          try {
            final message = jsonDecode(data as String);
            if (message is Map && message["message"] == "Authentication successful") {
              print("✅ Authentification confirmée, début des envois !");
              if (!isSending) sendPeriodicData();
            } else if (message is Map && message.containsKey("error")) {
              print("⚠️ Erreur serveur : ${message['error']}");
            }
          } catch (e) {
            print("❌ Erreur JSON : $e");
          }
        },
        onError: (error) {
          print("❌ Erreur WebSocket : $error");
          isWebSocketConnected = false;
          isChannelOpen = false;
        },
        onDone: () {
          print("⚠️ WebSocket fermé");
          isSending = false;
          isWebSocketConnected = false;
          isChannelOpen = false;
        },
      );
    } catch (e) {
      print("❌ Erreur de connexion WebSocket : $e");
      isWebSocketConnected = false;
      isChannelOpen = false;
    }
  }

  void sendPeriodicData() {
    if (isSending || channel == null || !isWebSocketConnected || !isChannelOpen) return;

    isSending = true;

    Future.doWhile(() async {
      if (channel == null || !isWebSocketConnected || !isChannelOpen) {
        isSending = false;
        return false;
      }

      final dataMessage = jsonEncode({
        "thingId": thingId,
        "temperature": 20 + (5 * (1 - 2 * (DateTime.now().second % 2))),
        "timestamp": DateTime.now().toIso8601String(),
      });

      try {
        channel?.sink.add(dataMessage);
        print("📤 Données envoyées : $dataMessage");
      } catch (e) {
        print("❌ Erreur à l'envoi : $e");
        isSending = false;
        return false;
      }

      await Future.delayed(Duration(seconds: 5));
      return true;
    });
  }

  void closeConnection() {
    isSending = false;
    isWebSocketConnected = false;
    isChannelOpen = false;
    channel?.sink.close();
    print("🛑 Connexion WebSocket fermée manuellement");
  }
}
