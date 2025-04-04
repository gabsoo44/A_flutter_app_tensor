import 'package:a_flutter_app_tensor/screens/home_screen.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';  // Importer le client WebSocket
import 'package:flutter/material.dart';

/// Root widget of the application.
/// Initializes and runs the app by injecting the root widget `MyApp`.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThingClient _thingClient;  // Déclarer le client WebSocket

  @override
  void initState() {
    super.initState();
    _thingClient = ThingClient();  // Initialiser le client WebSocket
    _thingClient.connectToWebSocket();  // Connexion WebSocket
  }

  @override
  void dispose() {
    super.dispose();
    _thingClient.closeConnection();  // Fermer la connexion WebSocket proprement à la fermeture de l'application
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,  // Désactiver le banner de debug
        title: 'Capteur Température',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),  // Première page qui sera affichée
      );
}
