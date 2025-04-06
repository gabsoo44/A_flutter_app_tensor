import 'package:a_flutter_app_tensor/router.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThingClient _thingClient;

  @override
  void initState() {
    super.initState();
    _thingClient = ThingClient();
    _thingClient.connectToWebSocket('ws://10.51.116.67:5001');
  }

  @override
  void dispose() {
    _thingClient.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Capteur Température',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter, // <-- C'est ici qu'on active GoRouter
    );
}
