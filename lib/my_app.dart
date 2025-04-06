import 'package:a_flutter_app_tensor/router.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';
import 'package:flutter/material.dart';

/// Root widget of the application.
///
/// This widget initializes the WebSocket client (ThingClient)
/// and sets up routing and theming for the app.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Instance of the WebSocket client used to communicate with the server.
  late ThingClient _thingClient;

  /// Initializes the WebSocket connection when the app starts.
  @override
  void initState() {
    super.initState();
    _thingClient = ThingClient();

    // Replace this IP with your local server IP if needed.
    _thingClient.connectToWebSocket('ws://10.51.116.67:5001');
  }

  /// Cleans up the WebSocket connection when the app is disposed.
  @override
  void dispose() {
    _thingClient.closeConnection();
    super.dispose();
  }

  /// Builds the main MaterialApp using router configuration.
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Capteur Température',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: appRouter, // Navigation config defined in router.dart
      );
}
