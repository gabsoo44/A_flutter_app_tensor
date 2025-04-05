import 'dart:io';

void main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 5001);
  print('✅ FakeServer listening on ws://${server.address.address}:${server.port}');

  await for (HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      final socket = await WebSocketTransformer.upgrade(request);
      print('🔌 Client connecté');

      socket.listen(
        (message) => print('📩 Reçu du client : $message'),
        onDone: () => print('❌ Client déconnecté'),
        onError: (e) => print('⚠️ Erreur : $e'),
      );
    }
  }
}
